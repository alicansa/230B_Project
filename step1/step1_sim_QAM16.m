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

%%16-QAM
N=16;

%%16-QAM constallation test
bits_16 = '0000000100100011010001010110011110001001101010111100110111101111';
[quadrature_16 inphase_16] = QAM_16_mod(bits_16,N);
scatter(quadrature_16,inphase_16);
test_decode_16 = QAM_16_demod(inphase_16,quadrature_16);
test_ber_16 = BER(bits_16,test_decode_16);

%%16-QAM simulation

%
%bits_16 = random_bit_generator(N);
%[quadrature_16 inphase_16] = QAM_16_mod(bits_16,N/4);
impulse_train_quad_16 = impulse_train(overSampleSize,N,quadrature_16);
impulse_train_inphase_16 = impulse_train(overSampleSize,N,inphase_16);
figure;
stem(impulse_train_quad_16);
figure;
stem(impulse_train_inphase_16);



%
transmit_quad_16 = conv(impulse_train_quad_16,srrc,'same');
transmit_inphase_16 = conv(impulse_train_inphase_16,srrc,'same');
figure;
stem(transmit_quad_16);
figure;
stem(transmit_inphase_16);

%pass through channel



%matched filter
matched_output_quad = conv(transmit_quad_16,srrc,'same');
matched_output_inphase = conv(transmit_inphase_16,srrc,'same');

figure;
plot(matched_output_quad);
hold on
stem(impulse_train_quad_16,'r');


figure;
plot(matched_output_inphase);
hold on
stem(impulse_train_inphase_16,'r');


%sampler
sampled_quad = sampler(matched_output_quad,overSampleSize,Ts);
sampled_inphase = sampler(matched_output_inphase,overSampleSize,Ts);




%decision
output_bits = QAM_16_demod(sampled_inphase,sampled_quad);

%BER calculation
ber_16 = BER(bits_16(5:16),output_bits(5:16));

%%64-QAM
N=64;
%%64-QAM constellation test
bits_64 = '000000000001000010000011000100000101000110000111001000001001001010001011001100001101001110001111010000010001010010010011010100010101010110010111011000011001011010011011011100011101011110011111100000100001100010100011100100100101100110100111101000101001101010101011101100101101101110101111110000110001110010110011110100110101110110110111111000111001111010111011111100111101111110111111';
[quadrature_64 inphase_64] = QAM_64_mod(bits_64,N);
scatterplot(quadrature_64+j*inphase_64);
test_decode_64 = QAM_64_demod(inphase_64,quadrature_64);
test_ber_64 = BER(bits_64,test_decode_64);

%%64-QAM simulation
bits = random_bit_generator(N);
[quadrature inphase] = QAM_64_mod(bits,N);
impulse_train_quad_64 = impulse_train(overSampleSize,N,quadrature);
impulse_train_inphase_64 = impulse_train(overSampleSize,N,inphase);
