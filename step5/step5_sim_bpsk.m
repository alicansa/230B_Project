%Simulation for the BPSK modulation scheme
close all;
clear all;
%Start by setting the initial variables
N= 5000; %number of bits generated
overSampleSize = 4;
t_channel1=0:1/overSampleSize:N;
t_channel2=0:1/overSampleSize:N+2;
t_channel3=-1:1/overSampleSize:N+1;

rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=1; %average signal power for BPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth

srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:20;  %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,1,B); %convert given SNR levels to EbNo
k = 1;  % bits per symbol
bits = random_bit_generator(N);%random bit generation
sym = bpsk_mod(bits,N/k);%mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train = impulse_train(overSampleSize,N/k,sym);
transmit = conv(impulse_train,srrc,'same');
figure(1);
plot(t_channel1(1:100),real(transmit(1:100)),'r');
hold on

for k=1:3


    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    num = 1;

    if k==1
        %channel 1
        h = [1 0 0 0 0.25];
        transmit_channel = bandlimited_channel(h,transmit);
        figure(1)
        plot(t_channel1(1:100),real(transmit_channel(1:100)),'g');
        
        %channel equalizers
        %ZF
        L = 5; % number of taps
        c = ZFEqualizer(h,L);
        
    elseif k==2
        %channel 2
        h=[1 0 0 0 -0.25 0 0 0 0.125];
        transmit_channel = bandlimited_channel(h,transmit);
        figure(1)
        plot(t_channel2(1:100),real(transmit_channel(1:100)),'-ko');
        
        %channel equalizers
        %ZF
        L = 5; % number of taps
        c = ZFEqualizer(h,L);
    else
       %channel 3
       h=[0.1 0 0 0 1 0 0 0 -0.25];
        transmit_channel = bandlimited_channel(h,transmit);
        figure(1)
        plot(t_channel3(5:105),real(transmit_channel(5:105)),'-bx');
        
        %channel equalizers
        %ZF
        L = 5; % number of taps
        c = ZFEqualizer(h,L);
        
    end
    
    f = figure;
    for i=1:length(SNR)
        
        %pass the signals to be transmitted through awgn channel
        received = awgn_channel(transmit_channel,SNR(i),S);
     
        
        %equalize channel
        received_equalized = conv(received,c);
        
        
        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received_equalized,srrc,'same');

        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);
 
        % constellation
        if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
                SNR(i) == 15 || SNR(i) == 20
            subplot(2,3,num);
            scatter(sampled,zeros(1,length(sampled)),'*');
            xlim = [1.5*min(sampled) 1.5*max(sampled)];
            ylim = [-2 2];
            line(xlim,[0 0], 'Color', 'k');
            line([0 0],ylim,'Color', 'k');
            xlabel('In-Phase'),ylabel('Quadrature-Phase');
            title(['BPSK Constellation with'...
                sprintf('\nSNR = %d dB',SNR(i))]);
            axis([xlim, ylim]);
            num = num+1;
        end
        
        
        %pass the received symbols through ML-decision box
        output_bits = bpsk_demod(sampled);
        
        %BER calculation - drop the first bit
        ber(i) = BER(bits(2:N),output_bits(2:N));
        %BER theoretical calculation
        a = 10^(EbN0(i)/10);
        ber_theo(i) = qfunc(sqrt(2*a));
    end
    % save the constellation plot
    print(f,'-djpeg','-r300','bpConst');
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ber, 'ko');
    hold on;
    semilogy(SNR,ber_theo, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('Simulation (Bit Error)','Theory (Bit Error)');
    % save the BER graph
    print(h,'-djpeg','-r300','bpSNR');
end