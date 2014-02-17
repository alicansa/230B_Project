%% STEP 2 QPSK
%Simulation for the QPSK modulation scheme
close all;
clear all;
clc;
%Start by setting the initial variables
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 2/10^6; %Symbol period (10Mbps)
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = 0:20; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 2000;  %number of bits generated
k = 2;  % bits per symbol
phase_offsets = [5,10,20,45]; %phase offsets for simulation
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');

for y=1:length(phase_offsets)
    %pass the signals through phase offset block
    transmit_phase_offset = phase_offset(pi*phase_offsets(y)/180,transmit_inphase+j*transmit_quad);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    % declare variables
    h = zeros(1,5);
    ser = zeros(1,length(SNR));
    ser_theo = zeros(1,length(SNR));
    ber_EbN0 = zeros(1,length(SNR));
    f = figure;
    num = 1;
    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel

        received = awgn_complex_channel(transmit_phase_offset,SNR(i),S);

        %pass the received signal through the matched filter for optimal
        %detection
        matched_output = conv(received,srrc,'same');

        %pass the matched filter output through the sampler to obtain symbols
        %at each symbol period
        sampled = sampler(matched_output,overSampleSize,Ts);
        %constellation plot
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
        output_bits = qpsk_demod(real(sampled),imag(sampled));

        %SER calculation - drop first symbol   
        ser(i) = SER(bits(3:N),output_bits(3:N),k);
        %SER theoretical calculation
        a = 10^(EbN0(i)/10);
        ser_theo(i) = (qfunc(sqrt(2*a*sin(pi/4 - ...
            pi*phase_offsets(y)/180)))+ qfunc(sqrt(2*a*sin(pi/4 + ...
            pi*phase_offsets(y)/180))));
    end

    % save the constellation plot
    print(f,'-djpeg','-r300',strcat('qpConstpo',num2str(y)));

    %plot theoretical/simulation BER vs SNR graph
    g=figure;
    hold on;
    semilogy(SNR,ser,'bo');
    semilogy(SNR,ser_theo,'g');
    ylabel('Probability of Error');
    xlabel('Signal To Noise (dB)');
    title(strcat('SNR Comparison at ',...
        num2str(phase_offsets(y)), ' Degree Offset'));
    legend('Simulation(Symbol Error)',...
        'Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(g,'-djpeg','-r300',strcat('qpSNRpo',num2str(y)));
end