close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.1;
Ts = 1;
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [3 4 5 6 7 8 9 10 11 12 13 14 15 16];

EbN0 = SNR2EbN0(SNR,2);

%%QPSK simulation
N= 1000;

%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
[quadrature, inphase] = qpsk_mod(bits,N/2);

%mapping symbols to signals
impulse_train_quad = impulse_train(overSampleSize,N/2,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/2,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


%loop this section for BER vs SNR graphs

ber = zeros(1,length(SNR));
ber_theo = zeros(1,length(SNR));
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

    %decision
    output_bits = qpsk_demod(sampled_inphase,sampled_quad);

    %BER/SER calculation
    ber(i) = BER(bits(3:N),output_bits(3:N));    
    ser(i) = SER(bits,output_bits,2);
    %SER/BER theoretical calculation (BER=SER due to grey coding)
    a = 10^(EbN0(i)/10);
    ber_theo(i) = 2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2;
end


%plot theoretical/simulation BER vs SNR graph

h=figure;
semilogy(SNR,ser,'r');
hold on;
%semilogy(SNR,ser, 'b');
semilogy(SNR,ber_theo, 'g');
ylabel('');
xlabel('');
