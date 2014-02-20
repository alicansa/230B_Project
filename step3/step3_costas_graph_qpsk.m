clear all
close all
clc;

filename = 'step3_costas_freq_qpsk';
load(filename);
%filename = 'step3_costas_phase_qpsk';
%load(filename);




% loaded items

% SNR - the array of SNR levels 
% freq_offsets - the array of offset levels

% samples{y,i}(time)  - CELL ARRAY -  the sampled data for constellation plots
%     - rows of each frequency offset
%     - columns of the SNR levels
%     - index is the sample index
%     
% ber(y,i) - the ber for simulated trials
%     - rows of each frequency offset
%     - columns of 2 SNR levels
%     
% ber_theo(y,i)  - the theoretical ber of the mod scheme
%     - rows are each of the freq offsets
%     - columns are each of the 2 SNR levels


for y=1:length(freq_offsets) % freq offset
    f = figure;
    for i = 1:2  % SNR level
        subplot(2,1,i);
           scatter(real(samples{y,i}),imag(samples{y,i}),'*');
           xlim = [1.5*min(real(samples{y,i})) 1.5*max(real(samples{y,i}))];
           ylim = [1.5*min(imag(samples{y,i})) 1.5*max(imag(samples{y,i}))];
           line(xlim,[0 0], 'Color', 'k');
           line([0 0],ylim,'Color', 'k');
           xlabel('In-Phase'),ylabel('Quadrature-Phase');
           tit = ['SNR = ',num2str(SNR(i)),' dB'];
           title(tit);
           axis([xlim, ylim]);
           
    end
    % save the constellation plot
%     print(f,'-djpeg','-r300',strcat('bpConstfo',num2str(k)));
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ber(y,:), 'ko');
    hold on;
    semilogy(SNR,ber_theo(y,:), 'b');
    title(['BPSK SNR Comparison at ', ...
        num2str(freq_offsets(y)), ' Hz Offset']);
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('Simulation (Bit Error)','Theory (Bit Error)');
    % save the BER graph
%     print(h,'-djpeg','-r300',strcat('bpSNRfo',num2str(k)));
    
end