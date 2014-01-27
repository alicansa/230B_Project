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

%% QPSK
N=16;

%%16-QAM constallation test
bits = '00011110010011010110100101011011';
[quadrature, inphase] = qpsk_mod(bits,N);
scatter(quadrature,inphase);
test_decode = QAM_16_demod(inphase,quadrature);
test_ber = BER(bits,test_decode);

%%qpsk 

impulse_train_quad = impulse_train(overSampleSize,N,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N,inphase);
figure;
stem(impulse_train_quad);
figure;
stem(impulse_train_inphase);



%
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');
figure;
stem(transmit_quad);
figure;
stem(transmit_inphase);

%pass through channel



%matched filter
matched_output_quad = conv(transmit_quad,srrc,'same');
matched_output_inphase = conv(transmit_inphase,srrc,'same');

figure;
plot(matched_output_quad);
hold on
stem(impulse_train_quad,'r');


figure;
plot(matched_output_inphase);
hold on
stem(impulse_train_inphase,'r');


%sampler
sampled_quad = sampler(matched_output_quad,overSampleSize,Ts);
sampled_inphase = sampler(matched_output_inphase,overSampleSize,Ts);




%decision
output_bits = qpsk_demod(sampled_inphase,sampled_quad);

%BER calculation
ber_qpks = BER(bits,output_bits);

