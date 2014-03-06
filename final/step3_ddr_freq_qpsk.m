%% STEP 3 QPSK
%Simulation for the QPSK modulation scheme
close all;
clear all;
clc;
%Start by setting the initial variables
output_bits = '';
overSampleSize = 4; %use higher oversampling rate to see the transient 
                        %phase of the loop filter output
rollOffFactor = 0.25;
Ts = 1/10^8; %Symbol period (1Mbps)
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = [1,2,3,4,5,6,7,8,9,10,15,20,30]; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 5000;  %number of bits generated
k = 2;  % bits per symbol

freq_offsets = [100000]; %freq offsets for simulation. 1ppm and 30 ppm respectively. 
                         %Fs = 10^6/2 for 1Mbps 
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating an impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');



for y=1:length(freq_offsets)
    %pass the signals through phase offset block
    transmit_freq_offset = freq_offset(freq_offsets(y),...
        Ts,transmit_inphase+j*transmit_quad);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    % declare variables
    h = zeros(1,5);
    ber_EbN0 = zeros(1,length(SNR));
    f = figure(1);
    f2 = figure(2);
    num = 1;
    num2=1;
    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel

        received = awgn_complex_channel(transmit_freq_offset,SNR(i),S);
        output_bits = '';
        
        %initialize feedback parameters
        vco_output = 0;
        phase_estimate = 0;
        delayed_moving_av_input = 0;
        delayed_vco_output = 0 ;
        moving_av_input = 0;
        phase_acc_output = 0;
        delayed_moving_av_output = 0;
        delayed_phase_acc_output = 0 ;
        
        %pass symbol-by-symbol in order to simulate the feedback loop
        for k=1:length(received)/overSampleSize
            
            delayed_moving_av_input = delayed_moving_av_output;
            delayed_phase_acc_output = phase_acc_output;
            
            %do correction
            corr_received = exp(-j*vco_output)*received((k-1)*overSampleSize+1:k*overSampleSize);
            
            %pass the received signal through the matched filter for optimal
            %detection
            matched_output_symbol = conv(corr_received,srrc,'same');
    
            
            %pass the matched filter output through the
            % sampler to obtain symbols at each symbol period
            sampled(k) = sampler(matched_output_symbol,overSampleSize,Ts); 
            
            %pass the received symbols through ML-decision box 
            [output_bit,output_symbol] = qpsk_demod(real(sampled(k)),...
                imag(sampled(k)));
            
            %estimate the phase
            phase_estimate = asin(imag(sampled(k)*conj(output_symbol))...
                /(abs(sampled(k))*abs(output_symbol)));
            
            % Then pass through loop filter
            moving_av_input = phase_estimate;

            [moving_av_output, delayed_moving_av_output] = ...
                loop_filter(moving_av_input,delayed_moving_av_input,0.05,0.001);
            
            
            if (SNR(i) == 6)
                loop_filter_output(k) = moving_av_output;
            
            elseif (SNR(i) == 30)
                loop_filter_output(k) = moving_av_output;
            end
            
            %pass through VCO
            [vco_output, phase_acc_output] = voltage_controlled_osc(moving_av_output,delayed_phase_acc_output);             
           
            %merge bits
            output_bits = strcat(output_bits,output_bit);
        end
            
        
        if (SNR(i) == 6 || SNR(i) == 30)
            %constellation plot
            figure(1);
            subplot(2,1,num);
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
            
            %plot loop filter output
            figure(2);
            subplot(2,1,num2);
            plot(loop_filter_output);
            xlabel('Samples'),ylabel('Phase Error Estimate');
            tit = strcat('SNR=',num2str(SNR(i)),' dB');
            title(tit);
            num2=num2+1;
            
        end
        
        %BER calculation   
        ber(i) = BER(bits(3:N),output_bits(3:N));
        ser(i) = SER(bits(3:N),output_bits(3:N),2); 
    end
    
    f3=figure(3);
    semilogy(SNR,ber,'b');
    hold on;
    semilogy(SNR,ser,'-ko');
    xlabel('SNR (dB)');
    ylabel('BER');
    legend('Measure starting from beginning','Measure starting from 200th bit', ...
       'Measure starting from 500th bit','Measure starting from 1000th bit' );

    % save the constellation plot
    print(f,'-djpeg','-r300',strcat('qpConstfo_ddr',num2str(y)));
    print(f2,'-djpeg','-r300',strcat('qpLoopFilterfo_ddr',num2str(y)));
    print(f3,'-djpeg','-r300',strcat('qpBERfo_ddr',num2str(y)));

    hold off
end