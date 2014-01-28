close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.1;
Ts = 1;
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [3 6 10 20];

%%16-QAM simulation
N= 5000;
%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
[quadrature inphase] = QAM_16_mod(bits,N/4);

%mapping symbols to signals
impulse_train_quad = impulse_train(overSampleSize,N/4,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/4,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


%loop this section for BER vs SNR graphs
ber = zeros(1,length(SNR));
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
    output_bits = QAM_16_demod(sampled_inphase,sampled_quad);

    %BER calculation
    ber(i) = BER(bits(5:N),output_bits(5:N));    
end

%plot BER vs SNR graph

h=figure;
semilogy(SNR,ber);
ylabel('Bit Error Rate');
xlabel('Signal to Noise');
title('BER vs SNR');