%Simulation for the QPSK modulation scheme
close all;
clearvars;
clc;
%Start by setting the initial variables
overSampleSize = 4;
overSampleSizeAnalog = 320; %80 times symbol rate
rollOffFactor = 0.75;
Fs = 10^10; %sampling frequency
Ts = 1/Fs; %Symbol period
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 20; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 5000;  %number of bits generated
k = 2;  % bits per symbol
f_offset = 0; %frequency offset 100kHz
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
%digital to analog conversion
transmit_analog = ZeroHoldInterpolation(transmit,overSampleSizeAnalog/overSampleSize);
%anti aliasing filter
filtered_transmit_analog = ButterworthFilter(4,0.05,transmit_analog); %fc at pi/4
%frequency offset
filtered_transmit_analog_offset = freq_offset(f_offset,...
        Ts,filtered_transmit_analog);
%bandlimited channel
h = zeros(1,2801);
h(1) = 0.1;
h(701) = 0.8;
h(1401) = 0.95;
h(2101) = 0.7;
h(2801) = 0.35;
L = 2801; % number of taps
%c = ZFEqualizer(h,L);

%pass through bandlimited channel
ISI_filtered_transmit_analog_offset = conv(filtered_transmit_analog_offset,...
                                        upsample(h,overSampleSizeAnalog));
                                        
ISI_filtered_transmit_analog_offset = ...
    ISI_filtered_transmit_analog_offset(overSampleSizeAnalog*...
                        1400+1:end-overSampleSizeAnalog*1401);

%loop this section for the generation of BER vs SNR graphs and
%constellation plots
% declare variables
ser_theo = zeros(1,length(SNR));
ber_EbN0 = zeros(1,length(SNR));
f = figure;
num = 1;

for i=1:length(SNR)
   %pass the signals to be transmitted through awgn channel
    received_analog = awgn_complex_channel(transmit ...
        ,SNR(i),S);
    %noise limiting filter
    filtered_received_analog = ButterworthFilter(4,0.02,received_analog);
    %analog to digital converter
    received_digital = ZeroHoldDecimation(filtered_received_analog,overSampleSizeAnalog/overSampleSize,1);

    %initialize feedback parameters
    
        vco_output = 0;
        phase_estimate = 0;
        delayed_moving_av_input = 0;
        delayed_vco_output = 0 ;
        moving_av_input = 0;
        phase_acc_output = 0;
        delayed_moving_av_output = 0;
        delayed_phase_acc_output = 0 ;
        
        %pass symbol-by-symbol in order to simulate the feedback loop
        for l=1:length(received_analog)
            
            delayed_moving_av_input = delayed_moving_av_output;
            delayed_phase_acc_output = phase_acc_output;
            
            %do correction
            corr_received(l) = exp(-j*vco_output)*received_analog(l);
            
            delayed_vco_output = vco_output;
            
            %seperate to real and imagenary parts
            im_received = real(corr_received(l));
            re_received = imag(corr_received(l));
            
            % gather the signs
            im_sign = tanh(im_received);
            re_sign = tanh(re_received);
            
            % come up with metric for phase error
            phase_estimate = -im_received*re_sign + re_received*im_sign;
            moving_av_input = phase_estimate;              
            [moving_av_output delayed_moving_av_output] = loop_filter(moving_av_input,delayed_moving_av_input,0.05,0.001);
            
            loop_filter_output(l) = moving_av_output;
            
            %pass through VCO
          %  [vco_output phase_acc_output] = voltage_controlled_osc(moving_av_output,...
          %      delayed_phase_acc_output);
        end
        
%         f = figure;
%         plot(loop_filter_output)
%           print(f,'-djpeg','-r300','loop_filter_qam20');
        
          %pass the received signal through the matched filter for optimal
            %detection
            matched_output = conv(corr_received,srrc,'same');
           f = eyediagram(matched_output,40,10^-9);
              print(f,'-djpeg','-r300','awgn_eye_qpsk5');
            %pass the matched filter output through the
            % sampler to obtain symbols at each symbol period
            sampled = sampler(matched_output,overSampleSize,Ts); 
    
             %Equalization
           %  sampled_equalized = conv(sampled,c);            
           % sampled_equalized = sampled_equalized((floor(L/2))+1:end-(floor(L/2)));
            %pass the received symbols through ML-decision box 
            [output_bits,output_symbols] = qpsk_demod(real(sampled),...
                imag(sampled));
    
    %constellation plot
    if (SNR(i) == 11) || SNR(i) == 12 || SNR(i) == 18 || ...
            SNR(i) == 10 || SNR(i) == 20
        subplot(2,3,num);
        scatter(real(sampled),imag(sampled),'*');
        xlim = [1.5*min(real(sampled)) 1.5*max(real(sampled))];
        ylim = [1.5*min(imag(sampled)) 1.5*max(imag(sampled))];
        line(xlim,[0 0], 'Color', 'k');
        line([0 0],ylim,'Color', 'k');
        xlabel('In-Phase'),ylabel('Quadrature-Phase');
        title(['QPSK Constellation with'...
            sprintf('\nSNR = %d dB',SNR(i))]);
        axis([xlim, ylim]);
        num = num+1;
    end
    
    
  
    %SER calculation - drop first symbol   
    ser(i) = SER(bits(5:N-4),output_bits(5:N-4),2);
    ber(i) = BER(bits(5:N-4),output_bits(5:N-4));
    %SER theoretical calculation
    a = 10^(EbN0(i)/10);
    ser_theo(i) = 2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2;
    ber_theo(i) = (1/2)*(2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2);
end

% save the constellation plot
print(f,'-djpeg','-r300','qpConst');

%plot theoretical/simulation BER vs SNR graph
g=figure;
semilogy(SNR,ser,'ro');
hold on;
semilogy(SNR,ber,'bx');
semilogy(SNR,ser_theo, 'b');
semilogy(SNR,ber_theo,'g');
ylabel('Probability of Error');
xlabel('Signal To Noise (dB)');
legend('Simulation(Symbol Error)','Simulation(Bit Error)','Theory (Symbol Error)',...
    'Theory (Bit Error)','Location','SouthWest');
% save the BER graph
print(g,'-djpeg','-r300','qpSNR');
