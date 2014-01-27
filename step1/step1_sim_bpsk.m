close all;
clear all;
overSampleSize = 8;
rollOffFactor = 0;
Ts = 1;

%%squareroot raised cosine test
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
stem(srrc);
figure
stem(conv(srrc,srrc,'same'));

%% BPSK
% constallation test
bits_2 = '01000101101';
N = length(bits_2);
[sym] = bpsk_mod(bits_2,N);
scatter(sym,zeros(1,N));
test_decode_2 = bpsk_demod(sym);
test_ber_2 = BER(bits_2,test_decode_2);

%%16-QAM simulation

%
%bits_16 = random_bit_generator(N);
%[quadrature_16 inphase_16] = QAM_16_mod(bits_16,N/4);
impulse_train = impulse_train(overSampleSize,N,sym);
figure;
stem(impulse_train);



%
transmit = conv(impulse_train,srrc,'same');
figure;
stem(transmit);

%pass through channel



%matched filter
matched_output = conv(transmit,srrc,'same');

figure;
plot(matched_output);
hold on
stem(impulse_train,'r');



%sampler
sampled = sampler(matched_output,overSampleSize,Ts);


%decision
output_bits = bpsk_demod(sampled);

%BER calculation
ber = BER(bits_2,output_bits);

