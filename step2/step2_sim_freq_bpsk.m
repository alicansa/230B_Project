%% STEP 2 BPSK
%Simulation for the BPSK modulation scheme
close all;
clear all;
%Start by setting the initial variables
N= 1000; %number of bits generated
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 1/10^6; %Symbol period (10Mbps)
S=1; %average signal power for BPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = 0:20;  %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,1,B); %convert given SNR levels to EbNo
k = 1;  % bits per symbol
bits = random_bit_generator(N);%random bit generation
sym = bpsk_mod(bits,N/k);%mapping to symbols
freq_offsets = [0.01,0.1,1,10]; %frequency offsets for the simulation

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train = impulse_train(overSampleSize,N/k,sym);
transmit = conv(impulse_train,srrc,'same');


for k=1:length(freq_offsets)
    %pass the signals through frequency offset block
    transmit_freq_offset = freq_offset(freq_offsets(k),Ts,transmit);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    num = 1;
    f = figure;
    for i=1:length(SNR)

        %pass the signals to be transmitted through awgn channel
        received = awgn_complex_channel(transmit_freq_offset,SNR(i),S);

        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received,srrc,'same');

        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);

        % constellation
        if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
                SNR(i) == 15 || SNR(i) == 20
           subplot(2,3,num);
           scatter(real(sampled),imag(sampled),'*');
           xlim = [1.5*min(real(sampled)) 1.5*max(real(sampled))];
            ylim = [1.5*min(imag(sampled)) 1.5*max(imag(sampled))];
             line(xlim,[0 0], 'Color', 'k');
           line([0 0],ylim,'Color', 'k');
           xlabel('In-Phase'),ylabel('Quadrature-Phase');
            tit = strcat('SNR=',num2str(SNR(i)),' dB');
            title(tit);
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
    print(f,'-djpeg','-r300',strcat('bpConstfo',num2str(k)));

    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ber, 'ko');
    hold on;
    semilogy(SNR,ber_theo, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('Simulation (Bit Error)','Theory (Bit Error)');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('bpSNRfo',num2str(k)));
end