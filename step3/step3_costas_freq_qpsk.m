%% STEP 3 BPSK
%Simulation for the BPSK modulation scheme
close all;
clear all;
clc;

filename = 'step3_costas_freq_qpsk';

%% STEP 3 QPSK
%Simulation for the QPSK modulation scheme
close all;
clear all;
clc;
%Start by setting the initial variables
output_bits = '';
overSampleSize = 4;
rollOffFactor = 0.25;
Ts = 2/10^6; %Symbol period (1Mbps)
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,4,Ts);
SNR = [6,30]; %SNR levels where the system will be simulated
EbN0 = SNR2EbN0(SNR,2,B); %convert given SNR levels to EbNo
N= 20000;  %number of bits generated
k = 2;  % bits per symbol
freq_offsets = [0.5 15]; %freq offsets for simulation. 
                         %1ppm and 30 ppm respectively. 
                         %Fs = 10^6/2 for 1Mbps 
bits = random_bit_generator(N);  %random bit generation
[quadrature, inphase] = qpsk_mod(bits,N/k);  %mapping to symbols

%mapping symbols to signals by generating an impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit_quad = conv(impulse_train_quad,srrc,'same');
transmit_inphase = conv(impulse_train_inphase,srrc,'same');


% data saving cells;
samples = cell(length(freq_offsets),5);
ber = cell(length(freq_offsets),length(SNR));
ber_theo = cell(length(freq_offsets),length(SNR));

for y=1:length(freq_offsets)
    %pass the signals through phase offset block
    transmit_freq_offset = freq_offset(freq_offsets(y),...
        Ts,transmit_inphase+j*transmit_quad);

    %loop this section for the generation of BER vs SNR graphs and
    %constellation plots
    % declare variables

    for i=1:length(SNR)
       %pass the signals to be transmitted through awgn channel

        received = awgn_complex_channel(transmit_freq_offset,SNR(i),S);
        output_bits = '';
        
        %initialize feedback parameters
%         vco_output = 0;
%         delayed_im_corr_received = 0;
%         delayed_re_corr_received = 0;
%         im_corr_received = [1 1 1 1];
%         re_corr_received = [1 1 1 1];
%         phase_estimate = 0;
%         delayed_moving_av_input = 0;
%         delayed_vco_output = 0 ;
%         moving_av_input = 0;
        
        %pass symbol-by-symbol in order to simulate the feedback loop
        for k=1:length(received)/overSampleSize
            
%             delayed_im_corr_received = im_corr_received;
%             delayed_re_corr_received = re_corr_received;
%             delayed_moving_av_input = moving_av_input;
%             delayed_vco_output = vco_output;
            
            %do correction
            corr_received = exp(-j*vco_output)*...
                received(((k-1)*overSampleSize+1):k*overSampleSize);
            
            delayed_im_corr_received = im_corr_received;
            delayed_re_corr_received = re_corr_received;
            delayed_moving_av_input = moving_av_input;
            delayed_phase_acc_output = phase_acc_output;
            
            %do correction
            corr_received = exp(-j*vco_output).*...
                received((k-1)*overSampleSize+1:k*overSampleSize);
            
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
            %seperate to real and imagenary parts
            im_corr_received = real(corr_received);
            re_corr_received = imag(corr_received);
            
            im_sign = sign(im_corr_received);
            re_sign = sign(re_corr_received);
            
            % come up with metric for phase error
            phase_estimate = im_corr_recieved*re_sign ...
                                + re_corr_received*im_sign;
                            
            
            
            %pass through VCO
            vco_output = voltage_controlled_osc(moving_av_output,...
                delayed_vco_output);
             
            %merge bits
            output_bits = strcat(output_bits,output_bit);
        end
            
        %constellation plot
        
            subplot(2,3,num);
            scatter(real(sampled),imag(sampled),'*');
            xlim = [1.5*min(real(sampled)) 1.5*max(real(sampled))];
            ylim = [1.5*min(imag(sampled)) 1.5*max(imag(sampled))];
            line(xlim,[0 0], 'Color', 'k');
            line([0 0],ylim,'Color', 'k');
            xlabel('In-Phase'),ylabel('Quadrature-Phase');
            tit = ['SNR = ',num2str(SNR(i)),' dB'];
            title(tit);
            axis([xlim, ylim]);
            num = num+1;
        
        %SER calculation - drop first symbol   
        ser{y,i} = SER(bits(3:N),output_bits(3:N),2);
        ber{y,i} = BER(bits(3:N),output_bits(3:N));

    end

    % save the constellation plot
    % print(f,'-djpeg','-r300',strcat('qpConstpo',num2str(y)));


end

fields = {'freq_offsets','SNR','ber','ber_theo','samples'};
% structs = struct('freq_offsets',freq_offsets,'SNR',SNR,'ber',ber,'ber_theo',ber_theo,'samples',cell2mat(samples));
save(filename,fields{:});