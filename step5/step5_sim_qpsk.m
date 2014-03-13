%Simulation for the QPSK modulation scheme
close all;
clearvars;
clc;
%Start by setting the initial variables
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 20; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 15000;  %number of bits generated
[trainerSymbols_quad trainerSymbols_inp] = qpsk_mod('111111111111111111111111111111111111111111',21);
t=0:1/overSampleSize:N/2;
t_channel=0:1/overSampleSize:N;
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/2);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
trainer_impulse_train_quad = impulse_train(overSampleSize,...
                            length(trainerSymbols_quad),trainerSymbols_quad);
trainer_impulse_train_inp = impulse_train(overSampleSize,...
                            length(trainerSymbols_inp),trainerSymbols_inp);                        
impulse_train_quad = impulse_train(overSampleSize,N/2,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/2,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
trainerSymbols_transmit = conv(trainer_impulse_train_inp + j*trainer_impulse_train_quad,srrc,'same');


%loop this section for the generation of BER vs SNR graphs and
%constellation plots
% declare variables
ser = zeros(1,length(SNR));
ser_theo = zeros(1,length(SNR));
ber_EbN0 = zeros(1,length(SNR));

for k=1:3
    num = 1;
    if k==1
        %channel 1
        h = [0 1 0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);

        %channel equalizers
        %ZF
        L = 3; % 3 taps
        c = ZFEqualizer(h,L);   
    elseif k==2
        %channel 2
        h=[0 0 1 -0.25 0.125];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(9:length(transmit_channel)-8);
 
        %channel equalizers
        %ZF
        L = 5; % 5 taps
        c = ZFEqualizer(h,L);
    else
       %channel 3
        h=[0.1 1 -0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);

        %channel equalizers
        %ZF
        L = 3; % 5 taps
        c = ZFEqualizer(h,L);
    end
    
   f = figure;
    
    for i=1:length(SNR)
          
        %MSSE training
        trainerSymbols_channel = bandlimited_channel(upsample(h,overSampleSize),trainerSymbols_transmit);
        trainerSymbols_channel = trainerSymbols_channel(5:length(trainerSymbols_channel)-4);
        trainerSymbols_noisy = awgn_complex_channel(trainerSymbols_channel,SNR(i),S);
        trainerSymbols_matched = conv(trainerSymbols_noisy,srrc,'same');
        trainerSymbols_sampled = sampler(trainerSymbols_matched,overSampleSize,Ts);
        c_mmse_dfe = MMSE_Equalizer_Train(trainerSymbols_inp+j*trainerSymbols_quad,trainerSymbols_sampled,L);

        
        
        %pass the signals to be transmitted through awgn channel
        [received variance] = awgn_complex_channel(transmit_channel,SNR(i),S);

        %MMSE
        c_mmse = MMSE_Equalizer(h,variance,L);
        
 %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received,srrc,'same');
        
        f =eyediagram(matched_output,10,10^-9);
         print(f,'-djpeg','-r300','matched_eye_qpsk20');
        
        
        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);
        
        %equalize channel
        received_equalized_zf = conv(sampled,c);
        received_equalized_zf = received_equalized_zf((floor(L/2))+1:end-(floor(L/2)));
        received_equalized_mmse = conv(sampled,c_mmse);
        received_equalized_mmse = received_equalized_mmse((floor(L/2))+1:end-(floor(L/2)));
        received_equalized_mmse_dfe = conv(sampled,c_mmse_dfe);
        received_equalized_mmse_dfe = received_equalized_mmse_dfe((floor(L/2))+1:end-(floor(L/2)));

        
        f =eyediagram(received_equalized_zf,10,10^-9);
          print(f,'-djpeg','-r300','equalized_eye_qpsk20');
          
        %pass the received symbols through ML-decision box
        output_bits_zf = qpsk_demod(real(received_equalized_zf),imag(received_equalized_zf));
        output_bits_mmse  = qpsk_demod(real(received_equalized_mmse),imag(received_equalized_mmse));
        output_bits_ne = qpsk_demod(real(sampled),imag(sampled));
        output_bits_mmse_dfe  = qpsk_demod(real(received_equalized_mmse_dfe),imag(received_equalized_mmse_dfe));
        %BER calculation - drop the first bit
        ser_zf(i) = SER(bits(2:N),output_bits_zf(2:N),2);
        ser_mmse(i) = SER(bits(2:N),output_bits_mmse(2:N),2);
        ser_mmse_dfe(i) = SER(bits(2:N),output_bits_mmse_dfe(2:N),2);
        ser_ne(i) = SER(bits(2:N),output_bits_ne(2:N),2);
        %SER theoretical calculation
        a = 10^(EbN0(i)/10);
        ser_theo(i) = 2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2;
        ber_theo(i) = (1/2)*(2*qfunc(sqrt(2*a))-qfunc(sqrt(2*a))^2);
    end
    
    % save the constellation plot
    print(f,'-djpeg','-r300',strcat('qpConst',num2str(k)));
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ser_zf, '-ko');
    hold on;
    semilogy(SNR,ser_mmse, '-g+');
    semilogy(SNR,ber_mmse_dfe, '-m^');
    semilogy(SNR,ser_ne, '-rx');
    semilogy(SNR,ser_theo, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('ZF Equalized Simulation (Bit Error)', ...
        'MMSE Equalized Simulation (Bit Error)','Simulation (Bit Error)','Theory (Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('qpSNR',num2str(k)));
end