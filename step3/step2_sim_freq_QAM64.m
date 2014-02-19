%% STEP 2 64-QAM
%Simulation for the QAM-64 modulation scheme
close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 6/10^6;%Symbol period (10Mbps)
S=42; %average signal power for 64-QAM
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = 0:20;%SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,6,B);%convert given SNR levels to EbNo
N=4800;%number of bits generated
bits = random_bit_generator(N);%random bit generation
[quadrature, inphase] = QAM_64_mod(bits,N/6);%mapping to symbols
freq_offsets = [0.01,0.1,1,10]; %frequency offsets for the simulation

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/6,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/6,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');

for k=1:length(freq_offsets)
    %pass the signals through phase offset block
    transmit_freq_offset = freq_offset(freq_offsets(k),Ts,transmit_inphase+j*transmit_quad);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    f = figure;
    num = 1;
    ber = zeros(1,length(SNR));
    ber_theo = zeros(1,length(SNR));
    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel
        received = awgn_complex_channel(transmit_freq_offset,SNR(i),S);

        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received,srrc,'same');

        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);

        % make constellation plot
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
        output_bits = QAM_64_demod(real(sampled),imag(sampled));

        %SER calculation - drop first symbol
        ser(i) = SER(bits(7:N),output_bits(7:N),6);
        ber(i) = BER(bits(7:N),output_bits(7:N));
        %SER theoretical calculation
        a = 10^(EbN0(i)/10);
        ser_theo(i) = 1-(1-(14/8)*qfunc(sqrt((18/63)*a)))^2;
        ber_theo(i) = (1/6)*(1-(1-(14/8)*qfunc(sqrt((18/63)*a)))^2);
    end
    % print the constellation plot
    print(f,'-djpeg','-r300',strcat('qam64Constfo',num2str(k)));

    %plot theoretical/simulation SER vs SNR graph
    h=figure;
    semilogy(SNR,ser, 'ko');
    hold on;
    semilogy(SNR,ber, 'bo');
    semilogy(SNR,ser_theo, 'r');
    semilogy(SNR,ber_theo, 'g');
    ylabel('Probability of Error');
        title(strcat('SNR Comparison at ',...
            num2str(freq_offsets(k)), ' Hz Offset'));
    xlabel('SNR(dB)');
    legend('Simulation(Symbol Error)',...
        'Simulation(Bit Error)','Theory(Symbol Error)',...
        'Theory(Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('qam64SNRfo',num2str(k)));
end