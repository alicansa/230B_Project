%Simulation for the QPSK modulation scheme
close all;
clear all;
clc;
%Start by setting the initial variables
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:20; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 20000;  %number of bits generated
t=0:1/overSampleSize:N/2;
k = 2;  % bits per symbol
t_channel=0:1/overSampleSize:N;
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
figure(1);
plot(t(1:100),real(transmit(1:100)),'r');
hold on
%loop this section for the generation of BER vs SNR graphs and
%constellation plots
% declare variables
h = zeros(1,5);
ser = zeros(1,length(SNR));
ser_theo = zeros(1,length(SNR));
ber_EbN0 = zeros(1,length(SNR));

for k=1:3
    num = 1;
    if k==1
        %channel 1
         h = [1 0 0 0 0.25];
        transmit_channel = bandlimited_channel(h,transmit);
        transmit_channel = transmit_channel(1:length(transmit_channel)-4);
        figure(1)
        plot(t_channel(1:100),real(transmit_channel(1:100)),'g');
        
        %channel equalizers
        %ZF
        L = 9; % number of taps
        c = ZFEqualizer(h,L,overSampleSize);   
    elseif k==2
%channel 2
        h=[1 0 0 0 -0.25 0 0 0 0.125];
        transmit_channel = bandlimited_channel(h,transmit);
        transmit_channel = transmit_channel(1:length(transmit_channel)-8);
        figure(1)
        plot(t_channel(1:100),real(transmit_channel(1:100)),'-ko');
        
        %channel equalizers
        %ZF
        L = 9; % number of taps
        c = ZFEqualizer(h,L,overSampleSize);
    else
  %channel 3
        h=[0.1 0 0 0 1 0 0 0 -0.25];
        transmit_channel = bandlimited_channel(h,transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);
        figure(1)
        plot(t_channel(1:100),real(transmit_channel(1:100)),'-bx');
        
        %channel equalizers
        %ZF
        L = 9; % number of taps
        c = ZFEqualizer(h,L,overSampleSize);
    end
    
    f = figure;
    
    for i=1:length(SNR)
          
        %pass the signals to be transmitted through awgn channel
        received = awgn_complex_channel(transmit_channel,SNR(i),S);

        %equalize channel
        received_equalized = conv(received,c);
        
        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received_equalized,srrc,'same');
        matched_output_ne = conv(received,srrc,'same');
        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);
        sampled_ne = sampler(matched_output_ne,overSampleSize,Ts);
        
        %constellation plot
        if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
                SNR(i) == 15 || SNR(i) == 20
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
        
        %pass the received symbols through ML-decision box
        output_bits = qpsk_demod(real(sampled),imag(sampled));
        output_bits_ne = qpsk_demod(real(sampled_ne),imag(sampled_ne));
        %SER calculation - drop first symbol
        ser(i) = SER(bits(3:N),output_bits(3:N),k);
        ser_ne(i) = SER(bits(3:N),output_bits_ne(3:N),k);
        ber(i) = BER(bits(3:N),output_bits(3:N));
        ber_ne(i) =  BER(bits(3:N),output_bits_ne(3:N));
        %SER theoretical calculation
        a = 10^(EbN0(i)/10);
        ser_theo(i) = 2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2;
        ber_theo(i) = (1/2)*(2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2);
    end
    
    % save the constellation plot
    print(f,'-djpeg','-r300','qpConst');
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR(1:20),ser(1:20), '-ko');
    hold on;
    semilogy(SNR(1:20),ser_ne(1:20), '-rx');
    semilogy(SNR(1:20),ser_theo(1:20), 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('ZF Equalized Simulation (Symbol Error)', 'Simulation (Symbol Error)','Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','bpSNR');
end