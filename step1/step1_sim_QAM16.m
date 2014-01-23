close all;
clear all;
overSampleSize = 4;


%%16-QAM
N=16;

%%16-QAM constallation test
bits_16 = '0000000100100011010001010110011110001001101010111100110111101111';
[quadrature_16 inphase_16] = QAM_16_mod(bits_16,N);
scatterplot(quadrature_16+j*inphase_16);
test_decode_16 = QAM_16_demod(inphase_16,quadrature_16);
test_ber_16 = BER(bits_16,test_decode_16);

%%16-QAM simulation
% bits = random_bit_generator(N);
% [quadrature inphase] = QAM_16_mod(bits,N);
% impulse_train_quad__16 = impulse_train(overSampleSize,N,quadrature);
% impulse_train_inphase_16 = impulse_train(overSampleSize,N,inphase);


%%64-QAM
N=64;
%%64-QAM constellation test
bits_64 = '000000000001000010000011000100000101000110000111001000001001001010001011001100001101001110001111010000010001010010010011010100010101010110010111011000011001011010011011011100011101011110011111100000100001100010100011100100100101100110100111101000101001101010101011101100101101101110101111110000110001110010110011110100110101110110110111111000111001111010111011111100111101111110111111';
[quadrature_64 inphase_64] = QAM_64_mod(bits_64,N);
scatterplot(quadrature_64+j*inphase_64);
test_decode_64 = QAM_64_demod(inphase_64,quadrature_64);
test_ber_64 = BER(bits_64,test_decode_64);

%%64-QAM simulation
% bits = random_bit_generator(N);
% [quadrature inphase] = QAM_64_mod(bits,N);
% impulse_train_quad_64 = impulse_train(overSampleSize,N,quadrature);
% impulse_train_inphase_64 = impulse_train(overSampleSize,N,inphase);
