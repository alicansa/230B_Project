close all;
clear all;
overSampleSize = 4;
rollOffFactor = 1;
Ts = 1;
S=1; %average signal power for BPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts);
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];

EbN0 = SNR2EbN0(SNR,1,B);

%%BPSK simulation
N= 10000;
k = 1;  % bits per symbol

% function checks
modTester = '011101';
expected = [-1 1 1 1 -1 1];
result = bpsk_mod(modTester,length(modTester)/k);
failed = sum(expected-result);
disp(['Number of failed I modulation symbols:' num2str(failed)]);

demodTester = expected;
expectedBits = bin2dec(modTester);
resultBits = bpsk_demod(demodTester);
failedBits = sum(expectedBits - bin2dec(resultBits));
disp(['Number of failed demodulated bits:' num2str(failedBits)]);

%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
sym = bpsk_mod(bits,N/k);

%mapping symbols to signals
impulse_train = impulse_train(overSampleSize,N/k,sym);
transmit = conv(impulse_train,srrc,'same');


%loop this section for BER vs SNR graphs

ber = zeros(1,length(SNR));
ber_theo = zeros(1,length(SNR));
for i=1:length(SNR)
   %pass through awgn channel
    received = awgn_channel(transmit,SNR(i),S);

    
    %matched filter
    matched_output = conv(received,srrc,'same');

    %sampler
    sampled = sampler(matched_output,overSampleSize,Ts);
    
    %decision
    output_bits = bpsk_demod(sampled);

    %BER calculation
    ber(i) = BER(bits(2:N),output_bits(2:N));    
    %BER theoretical calculation (BER=SER due to grey coding)
    a = 10^(EbN0(i)/10);
    ber_theo(i) = qfunc(sqrt(2*a));
    
end


%plot theoretical/simulation BER vs SNR graph

h=figure;
semilogy(SNR,ber, 'ko');
hold on;
semilogy(SNR,ber_theo, 'b');
title(['Comparison of Theoretical and Experimental',...
    sprintf('\nBPSK Bit Error Rates')]);
ylabel('BER');
xlabel('SNR (dB)');
legend('Simulation','Theory');
