%Sensitivity of TX filter cutoff frequency
close all;
clear all;
clc;

delay = 0:1:20;

N= 5000;  %number of bits generated

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
transmit_analog = ZeroHoldInterpolation(transmit,overSampleSizeAnalog/overSampleSize);


for f=1:length(delay)                                
    %anti aliasing filter
    filtered_transmit_analog = ButterworthFilter(4,0.05,transmit_analog);
    %pass the signals to be transmitted through awgn channel
    received_analog = awgn_complex_channel(filtered_transmit_analog,SNR,80*S);
    
    %noise limiting filter
    filtered_received_analog = ButterworthFilter(4,0.02,received_analog);

    %analog to digital converter -> sample 4 times each symbol period
    received_digital = ZeroHoldDecimation(filtered_received_analog,...
                        overSampleSizeAnalog/overSampleSize,delay(f));
    
    %pass the received signal through the matched filter for optimal
    %detection
    matched_output = conv(received_digital,srrc,'same');
    %pass the matched filter output through the sampler to obtain symbols
    %at each symbol period
    sampled = sampler(matched_output,overSampleSize,Ts);
    
    %pass the received symbols through ML-decision box 
    output_bits = qpsk_demod(real(sampled),imag(sampled));
  
    %SER calculation - drop first symbol   
    ser(f) = SER(bits(2*delay(f)+1:N-2*delay(f)),output_bits(2*delay(f)+1:N-2*delay(f)),k);
end

%% plot theoretical/simulation BER vs SNR graph
g=figure;
plot(delay,ser);
ylabel('Probability of Error');
xlabel('delay (samples)');
% save
print(g,'-djpeg','-r300','delaySensitivity');
