close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.1;
Ts = 1;
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [3  6  10 15 20];



EbN0 = SNR2EbN0(SNR,2);

%%QPSK simulation
N= 1000;
k = 2;  % bits per symbol

% function checks
modTester = '00011110';
expectedI = [-1 -1 1 1];
expectedQ = [-1 1 1 -1];
[resultI,resultQ] = qpsk_mod(modTester,length(modTester)/k);
failedI = sum(expectedI-resultI);
failedQ = sum(expectedQ-resultQ);
disp(['Number of failed I modulation symbols:' num2str(failedI)]);
disp(['Number of failed Q modulation symbols:' num2str(failedQ)]);

demodTesterI = expectedI;
demodTesterQ = expectedQ;
expectedBits = bin2dec(modTester);
resultBits = qpsk_demod(demodTesterI,demodTesterQ);
failedBits = sum(expectedBits - bin2dec(resultBits));
disp(['Number of failed demodulated bits:' num2str(failedBits)]);

%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
[quadrature, inphase] = qpsk_mod(bits,N/k);

%mapping symbols to signals
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


%loop this section for BER vs SNR graphs

% declare variables
h = zeros(1,5);
ber = zeros(1,length(SNR));
ser = zeros(1,length(SNR));
ber_SNR = zeros(1,length(SNR));
ber_EbN0 = zeros(1,length(SNR));

f = figure;
for i=1:length(SNR)
   %pass through awgn channel
    received_quad = awgn_channel(transmit_quad,SNR(i));
    received_inphase = awgn_channel(transmit_inphase,SNR(i));
    
    %matched filter
    matched_output_quad = conv(received_quad,srrc,'same');
    matched_output_inphase = conv(received_inphase,srrc,'same');

    %sampler
    sampled_quad = sampler(matched_output_quad,overSampleSize,Ts);
    sampled_inphase = sampler(matched_output_inphase,overSampleSize,Ts);

    
    
    subplot(2,3,i);
    scatter(sampled_inphase,sampled_quad);
    xlim = [1.5*min(sampled_inphase) 1.5*max(sampled_inphase)];
    ylim = [1.5*min(sampled_quad) 1.5*max(sampled_quad)];
    line(xlim,[0 0], 'Color', 'k');
        line([0 0],ylim,'Color', 'k');
    title(['QPSK Constellation with'...
        sprintf('\nSNR = %d dB',SNR(i))]);
    axis([xlim, ylim]);
    %decision
    output_bits = qpsk_demod(sampled_inphase,sampled_quad);
  
    %BER/SER calculation
    ber(i) = BER(bits(3:N),output_bits(3:N));    
    ser(i) = SER(bits,output_bits,k);
    %SER/BER theoretical calculation (BER=SER due to grey coding)
    a = 10^(EbN0(i)/10);
    ber_EbN0(i) = 1/2*erfc(sqrt(a));
    ber_SNR(i) = 2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2;
end




%plot theoretical/simulation BER vs SNR graph

g=figure;
semilogy(SNR,ber,'r');
hold on;
semilogy(SNR,ber_EbN0, 'b');
semilogy(SNR,ber_SNR, 'g');
title(['Comparison of Theoretical and Experimental',...
    sprintf('\nQPSK Bit Error Rates')]);
ylabel('Bit Error Rate (%)');
xlabel('Signal To Noise (dB)');
legend('Experimental','Eb/N0','Symbol SNR');

