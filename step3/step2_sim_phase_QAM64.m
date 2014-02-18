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
N=6000;%number of bits generated
phase_offsets = [5,10,20,45]; %phase offsets for simulation
bits = random_bit_generator(N);%random bit generation
[quadrature, inphase] = QAM_64_mod(bits,N/6);%mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/6,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/6,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


for k=1:length(phase_offsets)
    %pass the signals through phase offset block
    transmit_phase_offset = phase_offset(pi*phase_offsets(k)/180,transmit_inphase+j*transmit_quad);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    f = figure;
    num = 1;
    ber = zeros(1,length(SNR));
    ber_theo = zeros(1,length(SNR));
    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel
        received = awgn_complex_channel(transmit_phase_offset,SNR(i),S);

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
        

         ser_theo(i) = (4/16)*(qfunc(sqrt((18/63)*2*a*sin(pi/4 - ...
            pi*phase_offsets(k)/180)^2))+ qfunc(sqrt((18/63)*2*a*sin(pi/4 + ...
            pi*phase_offsets(k)/180)^2))) + 0.5*(qfunc(sqrt((18/63)*26*a*sin(pi/18 - ...
            pi*phase_offsets(k)/180)^2))+ qfunc(sqrt((18/63)*26*a*sin(pi/18 + ...
            pi*phase_offsets(k)/180)^2)));
        
        ber_theo(i) = (1/6)*(ser_theo(i));
    end
    % print the constellation plot
    print(f,'-djpeg','-r300',strcat('qam64Const',num2str(k)));

    %plot theoretical/simulation SER vs SNR graph
    h=figure;
    semilogy(SNR,ser, 'ko');
    hold on;
    semilogy(SNR,ber, 'bo');
    semilogy(SNR,ser_theo, 'r');
    semilogy(SNR,ber_theo, 'g');
    ylabel('Probability of Error');
    xlabel('SNR(dB)');
    title(['64-QAM SNR Comparison at ',...
        num2str(phase_offsets(k)), ' Degree Offset']);
    legend('Simulation(Symbol Error)','Simulation(Bit Error)','Theory(Symbol Error)',...
        'Theory(Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('qam64SNRpo',num2str(k)));
end