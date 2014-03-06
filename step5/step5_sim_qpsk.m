%Simulation for the QPSK modulation scheme
close all;
clearvars;
clc;
%Start by setting the initial variables
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:13; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 5000;  %number of bits generated
t=0:1/overSampleSize:N/2;
t_channel=0:1/overSampleSize:N;
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/2);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/2,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/2,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
% figure(1);
% plot(t(1:100),real(transmit(1:100)),'r');
% hold on
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
        h = [0 1 0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);
        %figure(1)
        %plot(t_channel(1:100),real(transmit_channel(5:104)),'g');
        
        %channel equalizers
        %ZF
        L = 3; % 3 taps
        c = ZFEqualizer(h,L,overSampleSize);   
    elseif k==2
        %channel 2
        h=[0 0 1 -0.25 0.125];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(9:length(transmit_channel)-8);
       % figure(1)
       % plot(t_channel(1:100),real(transmit_channel(1:100)),'-ko');
        
        %channel equalizers
        %ZF
        L = 5; % 5 taps
        c = ZFEqualizer(h,L,overSampleSize);
    else
       %channel 3
        h=[0.1 1 -0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);
       % figure(1)
       % plot(t_channel(1:100),real(transmit_channel(1:100)),'-bx');
        
        %channel equalizers
        %ZF
        L = 3; % 5 taps
        c = ZFEqualizer(h,L,overSampleSize);
    end
    
   % f = figure;
    
    for i=1:length(SNR)
          
        %pass the signals to be transmitted through awgn channel
        received = awgn_complex_channel(transmit_channel,SNR(i),S);

        %equalize channel
        received_equalized = conv(received,upsample(c,overSampleSize));
        received_equalized = received_equalized((floor(L/2))*overSampleSize+1:end-(floor(L/2))*overSampleSize);
        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received_equalized,srrc,'same');
        matched_output_ne = conv(received,srrc,'same');
        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);
        sampled_ne = sampler(matched_output_ne,overSampleSize,Ts);
        
        %constellation plot
%         if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
%                 SNR(i) == 15 || SNR(i) == 20
%             subplot(2,3,num);
%             scatter(real(sampled),imag(sampled),'*');
%             xlim = [1.5*min(real(sampled)) 1.5*max(real(sampled))];
%             ylim = [1.5*min(imag(sampled)) 1.5*max(imag(sampled))];
%             line(xlim,[0 0], 'Color', 'k');
%             line([0 0],ylim,'Color', 'k');
%             xlabel('In-Phase'),ylabel('Quadrature-Phase');
%             title(['QPSK Constellation with'...
%                 sprintf('\nSNR = %d dB',SNR(i))]);
%             axis([xlim, ylim]);
%             num = num+1;
%         end
%         
        %pass the received symbols through ML-decision box
        output_bits = qpsk_demod(real(sampled),imag(sampled));
        output_bits_ne = qpsk_demod(real(sampled_ne),imag(sampled_ne));
        %SER calculation - drop first symbol
        ser(i) = SER(bits(3:N),output_bits(3:N),2);
        ser_ne(i) = SER(bits(3:N),output_bits_ne(3:N),2);
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
    semilogy(SNR,ser, '-ko');
    hold on;
    semilogy(SNR,ser_ne, '-rx');
    semilogy(SNR,ser_theo, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('ZF Equalized Simulation (Symbol Error)', 'Simulation (Symbol Error)','Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('qpSNR',num2str(k)));
end