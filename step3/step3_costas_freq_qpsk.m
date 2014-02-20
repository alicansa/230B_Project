%% STEP 3 QPSK
%Simulation for the QPSK modulation scheme
close all;
clear all;
clc;


file = 'step3_costas_freq_qpsk';

%Start by setting the initial variables
output_bits = '';
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 2/10^6; %Symbol period (1Mbps)
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = [30]; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 20000;  %number of bits generated
k = 2;  % bits per symbol
freq_offsets = [0.5 15]; %freq offsets for simulation. 
                         %1ppm and 30 ppm respectively. 
                         %Fs = 10^6/2 for 1Mbps 
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating an impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');

% data saving arrays;
samples = cell(length(freq_offsets),length(SNR));
ber = zeros(length(freq_offsets),length(SNR));
ser = zeros(length(freq_offsets),length(SNR));
% ber_theo = zeros(length(freq_offsets),length(SNR));

for y=1:length(freq_offsets)
    num=1;
    %pass the signals through phase offset block
    transmit_freq_offset = freq_offset(freq_offsets(y),...
        Ts,transmit_inphase+1i*transmit_quad);

    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel

        received = awgn_complex_channel(transmit_freq_offset,SNR(i),S);
        output_bits = '';
        
        %initialize feedback parameters
        vco_output = 0;
        phase_estimate = 0;
        phase_delayed = 0;
        delayed_vco_output = 0 ;

        delayed_moving_av_input = 0;
        delayed_phase_acc_output = 0 ;
        moving_av_input = 0;
        phase_acc_output = 0;
        delayed_moving_av_output = 0;
         
        %pass symbol-by-symbol in order to simulate the feedback loop
        for k=1:length(received)/overSampleSize
                
            
            delayed_moving_av_input = delayed_moving_av_output;
            delayed_phase_acc_output = phase_acc_output;
            
            %do correction
            corr_received = exp(-j*vco_output)*received((k-1)*overSampleSize+1:k*overSampleSize);
            
            delayed_vco_output = vco_output;
            
            %pass the received signal through the matched filter for optimal
            %detection
            matched_output_symbol = conv(corr_received,srrc,'same');
    
            %pass the matched filter output through the
            % sampler to obtain symbols at each symbol period
            sampled(k) = sampler(matched_output_symbol,overSampleSize,Ts); 
            % save it for later
            samples{y,i}(k) = sampled(k);
            
            %seperate to real and imagenary parts
            im_received = real(sampled(k));
            re_received = imag(sampled(k));
            
            %pass the received symbols through ML-decision box 
            [output_bit,output_symbol] = qpsk_demod(im_received,...
                re_received);
            
            % gather the signs
            im_sign = tanh(im_received);
            re_sign = tanh(re_received);
            
            % come up with metric for phase error
            phase_estimate = -im_received*re_sign + re_received*im_sign;
            moving_av_input = phase_estimate;              
            [moving_av_output delayed_moving_av_output] = loop_filter(moving_av_input,delayed_moving_av_input);
            loop_filter_output(k) = moving_av_output;
            %pass through VCO
            [vco_output phase_acc_output] = voltage_controlled_osc(moving_av_output,...
                delayed_phase_acc_output);
             
            %merge bits
            output_bits = strcat(output_bits,output_bit);
        end
        
     %constellation plot
        
            subplot(2,3,num);
            scatter(real(sampled),imag(sampled),'*');
            xlim = [1.5*min(real(sampled)) 1.5*max(real(sampled))];
            ylim = [1.5*min(imag(sampled)) 1.5*max(imag(sampled))];
            line(xlim,[0 0], 'Color', 'k');
            line([0 0],ylim,'Color', 'k');
            xlabel('In-Phase'),ylabel('Quadrature-Phase');
            tit = strcat('SNR=',num2str(SNR(i)),' dB');
            title(tit);
            axis([xlim, ylim]);
            num = num+1;
            
        %SER calculation - drop first symbol   
        ser(y,i) = SER(bits(3:N),output_bits(3:N),2);
        ber(y,i) = BER(bits(3:N),output_bits(3:N));

    end
    figure
    plot(loop_filter_output);

end

fields = {'freq_offsets','SNR','ber','ser','samples'};
save(file,fields{:});