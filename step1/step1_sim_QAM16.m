close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.2;
Ts = 1;
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = [3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20];
%%16-QAM simulation
<<<<<<< HEAD
N= 30000;
=======
N= 5000;
>>>>>>> 51a84429e92d149fba3b5d071829c78dbaaa34a0
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
<<<<<<< HEAD

=======
ber = zeros(1,length(SNR));
>>>>>>> 51a84429e92d149fba3b5d071829c78dbaaa34a0
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

    %BER/SER calculation
    ber(i) = BER(bits(5:N),output_bits(5:N));    
    ser(i) = SER(bits(5:N),output_bits(5:N),4);
    %SER/BER theoretical calculation (BER=SER due to grey coding)
    a = 10^(SNR(i)/10);
   % ber_theo(i) = (1/4)*(2*qfunc(sqrt(a/2))-qfunc(sqrt(a/2))^2) + (2/4)*(3*qfunc(sqrt(a/2))-2*qfunc(sqrt(a/2))^2) + (1/4)*(4*qfunc(sqrt(a/2))-4*qfunc(sqrt(a/2))^2);
   ber_theo(i) = (1/4)*3/2*erfc(sqrt(4*0.1*(10.^(SNR(i)/10))));
end


%plot theoretical/simulation BER vs SNR graph

h=figure;
<<<<<<< HEAD
semilogy(SNR,ber,'r');
hold on;
semilogy(SNR,ser, 'b');
semilogy(SNR,ber_theo, 'g');
ylabel('');
xlabel('');



%plot SER vs snr
=======
semilogy(SNR,ber);
ylabel('Bit Error Rate');
xlabel('Signal to Noise');
title('BER vs SNR');
>>>>>>> 51a84429e92d149fba3b5d071829c78dbaaa34a0
