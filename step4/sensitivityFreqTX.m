%Sensitivity of TX filter cutoff frequency
close all;
clear all;
clc;

freqs = .01:.01:.99;  % cuttoff frequency of LPF on TX
del = 1; 

N= 1000;  %number of bits generated

load('qpskSetup');  % load in the setup variables
EbN0 = SNR2EbN0(SNR,2,B);
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit = conv(impulse_train_inphase + 1i*impulse_train_quad,srrc,'same');
%digital to analog conversion
transmit_analog = ZeroHoldInterpolation(transmit,overSampleSizeAnalog);


ser = zeros(1,length(freqs));
a = 10^(EbN0/10);
ser_theo =   ones(1,length(freqs))*(2*qfunc(sqrt(2*a))...
                                    -qfunc(sqrt(2*a))^2);

for f=1:length(freqs)                                
    %anti aliasing filter
    filtered_transmit_analog = ButterworthFilter(4,freqs(f),transmit_analog);
    %pass the signals to be transmitted through awgn channel
    received_analog = awgn_complex_channel(filtered_transmit_analog,SNR,S);
    
    %noise limiting filter
    filtered_received_analog = ButterworthFilter(4,0.1,received_analog);

    %analog to digital converter -> sample 4 times each symbol period
    received_digital = ZeroHoldDecimation(filtered_received_analog,...
                        overSampleSizeAnalog/overSampleSize,del);
    
    %pass the received signal through the matched filter for optimal
    %detection
    matched_output = conv(received_digital,srrc,'same');
    %pass the matched filter output through the sampler to obtain symbols
    %at each symbol period
    sampled = sampler(matched_output,overSampleSize,Ts);
    
    %pass the received symbols through ML-decision box 
    output_bits = qpsk_demod(real(sampled),imag(sampled));
  
    %SER calculation - drop first symbol   
    ser(f) = SER(bits(3:N),output_bits(3:N),k);
end
%% plot theoretical/simulation BER vs SNR graph
FS = 16; LW = 1.5;
g=figure;
plot(freqs,ser,'LineWidth',LW);
ylabel('Probability of Error','FontSize',FS-2);
xlabel('Normalized f_c','FontSize',FS-2);
legend('Simulation(Symbol Error)','Location','SouthWest');
title('Effect of Shifting f_c of TX Anti-Aliasing LPF','FontSize',FS);
% save
print(g,'-djpeg','-r300','freqTX');
