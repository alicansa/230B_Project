clear all
close all
clc;

filename = 'step3_sim_freq_bpsk';
load(filename);



ber = cell2mat(ber);
ber_theo = cell2mat(ber_theo);

% loaded items

% SNR - the array of SNR levels 
% freq_offsets - the array of offset levels

% samples{k,5}(time)  - CELL ARRAY -  the sampled data for constellation plots
%     - rows of each frequency offset
%     - columns of the 5 important SNR levels
%     - index is the sample index
%     
% ber(k,21) - the ber for simulated trials
%     - rows of each frequency offset
%     - columns of 21 SNR levels
%     
% ber_theo(k,21)  - the theoretical ber of the mod scheme
%     - rows are each of the freq offsets
%     - columns are each of the 21 SNR levels



for k=1:length(freq_offsets)
    
    
    f = figure;
    for i = 1:5
        subplot(2,3,i);
           scatter(real(samples{k,i}),imag(samples{k,i}),'*');
           xlim = [1.5*min(real(samples{k,i})) 1.5*max(real(samples{k,i}))];
           ylim = [1.5*min(imag(samples{k,i})) 1.5*max(imag(samples{k,i}))];
           line(xlim,[0 0], 'Color', 'k');
           line([0 0],ylim,'Color', 'k');
           xlabel('In-Phase'),ylabel('Quadrature-Phase');
           tit = ['SNR = ',num2str(SNR(i)),' dB'];
           title(tit);
           axis([xlim, ylim]);
    end
    % save the constellation plot
    print(f,'-djpeg','-r300',strcat('bpConstfo',num2str(k)));
    
    %plot theoretical/simulation BER vs SNR graph
    h=figure;
    semilogy(SNR,ber(k,:), 'ko');
    hold on;
    semilogy(SNR,ber_theo(k,:), 'b');
    title(['BPSK SNR Comparison at ', ...
        num2str(freq_offsets(k)), ' Hz Offset']);
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    legend('Simulation (Bit Error)','Theory (Bit Error)');
    % save the BER graph
    print(h,'-djpeg','-r300',strcat('bpSNRfo',num2str(k)));
    
end