%Simulation for the QAM-16 modulation scheme
close all;
clear all;
%Start by setting the initial variables
overSampleSize = 4;
overSampleSizeAnalog = 80; %80 times symbol period
rollOffFactor = 0.25;
N= 5000; %number of bits generated
t_analog = 0:1/overSampleSizeAnalog:N/4;
t_digital = 0:1/overSampleSize:N/4;
Ts = 1; %Symbol period
S=10; %average signal power for 16-QAM
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
SNR = 0:20; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,4,B); %convert given SNR levels to EbNo
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = QAM_16_mod(bits,N/4); %mapping to symbols

%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/4,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/4,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
%digital to analog conversion
transmit_analog = ZeroHoldInterpolation(transmit,overSampleSizeAnalog/overSampleSize);
figure(1)
% plot(t_digital(1:100),real(transmit(1:100)),'r');
hold on
% plot(t_analog(1:100*overSampleSizeAnalog/overSampleSize),real(transmit_analog(1:100*overSampleSizeAnalog/overSampleSize)),'g');

%anti aliasing filter
filtered_transmit_analog = ButterworthFilter(4,0.05,transmit_analog); %fc at pi/20
figure(1)
% plot(t_analog(1:100*overSampleSizeAnalog/overSampleSize),real(filtered_transmit_analog(1:100*overSampleSizeAnalog/overSampleSize)),'-bx');
%loop this section for the generation of BER vs SNR graphs and
%constellation plots
num = 1;
hold off
for i=1:length(SNR)
 %pass the signals to be transmitted through awgn channel
    received_analog = awgn_complex_channel(filtered_transmit_analog,SNR(i),S);
    figure
%     plot(t_analog(1:100*overSampleSizeAnalog/overSampleSize),real(received_analog(1:100*overSampleSizeAnalog/overSampleSize)),'g');
    hold on;
    %noise limiting filter
    filtered_received_analog = ButterworthFilter(4,0.5,received_analog); %fc at pi/5
%     plot(t_analog(1:100*overSampleSizeAnalog/overSampleSize),real(filtered_received_analog(1:100*overSampleSizeAnalog/overSampleSize)),'r');
    %analog to digital converter -> sample 4 times each symbol period
    received_digital = ZeroHoldDecimation(filtered_received_analog,overSampleSizeAnalog/overSampleSize,1);
    hold off
    figure
%     plot(t_digital(1:100),real(received_digital(1:100)),'bx')
    hold on
%     plot(t_digital(1:100),real(transmit(1:100)),'r');
    %stem(real(received_digital(1:100)),'ko');
    %pass the received signal through the matched filter for optimal
    %detection
    matched_output = conv(received_digital,srrc,'same');

     %pass the matched filter output through the sampler to obtain symbols
    %at each symbol period
    sampled = sampler(matched_output,overSampleSize,Ts);
    f=figure(3);
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
        title(['16-QAM Constellation with'...
            sprintf('\nSNR = %d dB',SNR(i))]);
        axis([xlim, ylim]);
        num = num+1;
    end
   
    %pass the received symbols through ML-decision box 
    output_bits = QAM_16_demod(real(sampled),imag(sampled));

    %BER/SER calculation - drop the first symbol 
    ser(i) = SER(bits(9:N-8),output_bits(9:N-8),4);
    ber(i) = BER(bits(9:N-8),output_bits(9:N-8));
    %SER/BER theoretical calculation)
    a = 10^(EbN0(i)/10);
    ser_theo(i) = 3*qfunc(sqrt((4/5)*a))-(9/4)*qfunc(sqrt((4/5)*a))^2;
    ber_theo(i) = (1/4)*(3*qfunc(sqrt((4/5)*a))-(9/4)*qfunc(sqrt((4/5)*a))^2);
    
end

% save the constellation plot
print(f,'-djpeg','-r300','qam16Const');

%plot theoretical/simulation BER vs SNR graph
h=figure;
semilogy(SNR,ser, 'ko');
hold on;
semilogy(SNR,ber, 'bo');
semilogy(SNR,ser_theo, 'b');
semilogy(SNR,ber_theo,'g');
ylabel('Probability of Error');
xlabel('SNR(dB)');
legend('Simulation(Symbol Error)','Simulation(Bit Error)','Theory (Symbol Error)',...
    'Theory (Bit Error)','Location','SouthWest');
% save the BER graph
print(h,'-djpeg','-r300','qam16SNR');
