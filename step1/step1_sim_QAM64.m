close all;
clear all;
overSampleSize = 4;
rollOffFactor = 1;
Ts = 1;
S=42; %average signal power for 64-QAM
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts);
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:20;


EbN0 = SNR2EbN0(SNR,6,B);

%%QPSK simulation
N=6000;

%random bit generation
bits = random_bit_generator(N);

%mapping to symbols
[quadrature, inphase] = QAM_64_mod(bits,N/6);

%mapping symbols to signals
impulse_train_quad = impulse_train(overSampleSize,N/6,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/6,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');

%loop this section for BER vs SNR graphs
f = figure;
num = 1;
ber = zeros(1,length(SNR));
ber_theo = zeros(1,length(SNR));
for i=1:length(SNR)
   %pass through awgn channel
    received_quad = awgn_channel(transmit_quad,SNR(i),S);
    received_inphase = awgn_channel(transmit_inphase,SNR(i),S);

    %matched filter
    matched_output_quad = conv(received_quad,srrc,'same');
    matched_output_inphase = conv(received_inphase,srrc,'same');
    
    %sampler
    sampled_quad = sampler(matched_output_quad,overSampleSize,Ts);
    sampled_inphase = sampler(matched_output_inphase,overSampleSize,Ts);

    % make constellation plot
    if (SNR(i) == 3) || SNR(i) == 6 || SNR(i) == 10 || ...
            SNR(i) == 15 || SNR(i) == 20
        subplot(2,3,num);
        scatter(sampled_inphase,sampled_quad,'*');
        xlim = [1.5*min(sampled_inphase) 1.5*max(sampled_inphase)];
        ylim = [1.5*min(sampled_quad) 1.5*max(sampled_quad)];
        line(xlim,[0 0], 'Color', 'k');
        line([0 0],ylim,'Color', 'k');
        xlabel('In-Phase'),ylabel('Quadrature-Phase');
        title(['64QAM Constellation with'...
            sprintf('\nSNR = %d dB',SNR(i))]);
        axis([xlim, ylim]);
        num = num+1;
    end
    
    %decision
    output_bits = QAM_64_demod(sampled_inphase,sampled_quad);

    %SER calculation
    ser(i) = SER(bits(7:N),output_bits(7:N),6);
    
    %SER theoretical calculation
    a = 10^(EbN0(i)/10);
    ser_theo(i) = 1-(1-(14/8)*qfunc(sqrt((18/63)*a)))^2;
end
% print the constellation plot
print(f,'-djpeg','-r300','qam64Const');

%plot theoretical/simulation SER vs SNR graph

h=figure;
semilogy(SNR,ser, 'ko');
hold on;
semilogy(SNR,ser_theo, 'r');
ylabel('Probability of Symbol Error');
xlabel('SNR(dB)');
legend('Simulation','Theory');
% save the BER graph
print(h,'-djpeg','-r300','qam64SNR');
