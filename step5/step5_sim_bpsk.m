%Simulation for the BPSK modulation scheme
close all;
clearvars
%Start by setting the initial variables
N= 1000; %number of bits generated
overSampleSize = 4;
t_channel=0:1/overSampleSize:N;

rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=1; %average signal power for BPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:13;  %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,1,B); %convert given SNR levels to EbNo
k = 1;  % bits per symbol
bits = random_bit_generator(N);%random bit generation
sym = bpsk_mod(bits,N/k);%mapping to symbols
trainerSymbols = bpsk_mod('111111111111111111111111111111111111111111',42);
%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
trans_impulse_train = impulse_train(overSampleSize,N/k,sym);
trainer_impulse_train = impulse_train(overSampleSize,...
                            length(trainerSymbols),trainerSymbols);
transmit = conv(trans_impulse_train,srrc,'same');
trainerSymbols_transmit = conv(trainer_impulse_train,srrc,'same');

% figure(1);
% plot(t_channel(1:100),real(transmit(1:100)),'r');
% hold on

for k=1:3
    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    num = 1;
    if k==1
        %channel 1
        h = [0 1 0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);
       % figure(1)
       % plot(t_channel(1:100),real(transmit_channel(5:104)),'g');
        
        %channel equalizers
        %ZF
        L = 3; % number of taps
        c = ZFEqualizer(h,L);
    elseif k==2
        %channel 2
        h=[0 0 1 -0.25 0.125];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(9:length(transmit_channel)-8);
      %  figure(1)
      %  plot(t_channel(1:100),real(transmit_channel(1:100)),'-ko');
        
        %channel equalizers
        %ZF
        L = 5; % number of taps
        c = ZFEqualizer(h,L);
    else
       %channel 3
        h=[0.1 1 -0.25];
        transmit_channel = bandlimited_channel(upsample(h,overSampleSize),transmit);
        transmit_channel = transmit_channel(5:length(transmit_channel)-4);
      %  figure(1)
      %  plot(t_channel(1:100),real(transmit_channel(1:100)),'-bx');
        
        %channel equalizers
        %ZF
        L = 3; % number of taps
        c = ZFEqualizer(h,L);
        
    end
    
  %  f = figure;
    for i=1:length(SNR)
        
        %MMSE training 
        
        trainerSymbols_channel = bandlimited_channel(upsample(h,overSampleSize),trainerSymbols_transmit);
        trainerSymbols_channel = trainerSymbols_channel(5:length(trainerSymbols_channel)-4);
        trainerSymbols_noisy = awgn_complex_channel(trainerSymbols_channel,SNR(i),S);
        trainerSymbols_matched = conv(trainerSymbols_noisy,srrc,'same');
        trainerSymbols_sampled = sampler(trainerSymbols_matched,overSampleSize,Ts);
        %c_mmse = MMSE_Equalizer(trainerSymbols,trainerSymbols_sampled,overSampleSize,L);
        
        
        %pass the signals to be transmitted through awgn channel
        [received varience] = awgn_channel(transmit_channel,SNR(i),S);
     
        
        %MMSE
        c_mmse = MMSE_Equalizer(h,varience,L);
        
        %equalize channel
        received_equalized_zf = conv(received,upsample(c,overSampleSize));
        received_equalized_zf = received_equalized_zf((floor(L/2))*overSampleSize+1:end-(floor(L/2))*overSampleSize);
        received_equalized_mmse = conv(received,upsample(c_mmse,overSampleSize));
        received_equalized_mmse = received_equalized_mmse((floor(L/2))*overSampleSize+1:end-(floor(L/2))*overSampleSize);
     
        %pass the received signal through the matched filter for optimal
        %detection
        matched_output_zf = conv(received_equalized_zf,srrc,'same');
        matched_output_mmse = conv(received_equalized_mmse,srrc,'same');        
        matched_output_ne = conv(received,srrc,'same');
        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled_zf = sampler(matched_output_zf,overSampleSize,Ts);
        sampled_mmse = sampler(matched_output_mmse,overSampleSize,Ts);
        sampled_ne = sampler(matched_output_ne,overSampleSize,Ts);
        
        % constellation equalized
%         if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
%                 SNR(i) == 15 || SNR(i) == 20
%             subplot(2,3,num);
%             scatter(sampled,zeros(1,length(sampled)),'*');
%             xlim = [1.5*min(sampled) 1.5*max(sampled)];
%             ylim = [-2 2];
%             line(xlim,[0 0], 'Color', 'k');
%             line([0 0],ylim,'Color', 'k');
%             xlabel('In-Phase'),ylabel('Quadrature-Phase');
%             title(['BPSK Constellation with'...
%                 sprintf('\nSNR = %d dB',SNR(i))]);
%             axis([xlim, ylim]);
%             num = num+1;
%         end
%         
        %pass the received symbols through ML-decision box
        output_bits_zf = bpsk_demod(sampled_zf);
        output_bits_mmse  = bpsk_demod(sampled_mmse);
        output_bits_ne = bpsk_demod(sampled_ne);
        %BER calculation - drop the first bit
        ber_zf(i) = BER(bits(2:N),output_bits_zf(2:N));
        ber_mmse(i) = BER(bits(2:N),output_bits_mmse(2:N));
        ber_ne(i) = BER(bits(2:N),output_bits_ne(2:N));
        %BER theoretical calculation
        a = 10^(EbN0(i)/10);
        ber_theo(i) = qfunc(sqrt(2*a));
    end
    % save the constellation plot
   % print(f,'-djpeg','-r300','bpConst');
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ber_zf, '-ko');
    hold on;
    semilogy(SNR,ber_mmse, '-g+');
    semilogy(SNR,ber_ne, '-rx');
    semilogy(SNR,ber_theo, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('ZF Equalized Simulation (Bit Error)', ...
        'MMSE Equalized Simulation (Bit Error)','Simulation (Bit Error)','Theory (Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('bpSNR',num2str(k)));
end