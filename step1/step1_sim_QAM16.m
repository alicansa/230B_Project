close all;
clear all;
overSampleSize = 4;
rollOffFactor = 1;
Ts = 1;
S=10; %average signal power for 16-QAM
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts);
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];

EbN0 = SNR2EbN0(SNR,4,B);

%%QPSK simulation
N= 30000;

%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
[quadrature, inphase] = QAM_16_mod(bits,N/4);

%mapping symbols to signals
impulse_train_quad = impulse_train(overSampleSize,N/4,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/4,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


%loop this section for BER vs SNR graphs

ber = zeros(1,length(SNR));
ber_theo = zeros(1,length(SNR));
for i=1:length(SNR)
   %pass through awgn channel
    received_quad = awgn_channel(transmit_quad,SNR(i),S);
    received_inphase = awgn_channel(transmit_inphase,SNR(i),S);
    
    
%      received_quad = awgn(transmit_quad,SNR(i));
%      received_inphase = awgn(transmit_inphase,SNR(i));
%     
    %matched filter
    matched_output_quad = conv(received_quad,srrc,'same');
    matched_output_inphase = conv(received_inphase,srrc,'same');
    
    %sampler
    sampled_quad = sampler(matched_output_quad,overSampleSize,Ts);
    sampled_inphase = sampler(matched_output_inphase,overSampleSize,Ts);
    scatterplot(sampled_inphase + j*sampled_quad);
    %decision
    output_bits = QAM_16_demod(sampled_inphase,sampled_quad);

    %BER/SER calculation
    ber(i) = BER(bits(5:N),output_bits(5:N));    
    ser(i) = SER(bits,output_bits,4);
    %SER/BER theoretical calculation (BER=SER due to grey coding)
    a = 10^(EbN0(i)/10);
    %ber_theo(i) = 3*qfunc(sqrt(2*a))-(9/4)*qfunc(sqrt(2*a))^2;
    ber_theo(i) = (1/4)*3/2*erfc(sqrt(4*0.1*a));
end


%plot theoretical/simulation BER vs SNR graph

h=figure;
semilogy(SNR,ser,'r');
hold on;
semilogy(SNR,ser, 'b');
semilogy(EbN0,ber_theo, 'g');
ylabel('');
xlabel('');
