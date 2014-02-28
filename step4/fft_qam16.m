close all;
clear all;
clc;

% the purpose of this document is to get a feel for the frequency
% differences along the progression of the model diagram.  refer to the
% system diagram in the report

variables = {'transmit_analog','filtered_transmit_analog','transmit',...
    'received_analog','filtered_received_analog','received_digital',...
    'overSampleSize','overSampleSizeAnalog','Ts','S','N'};
load('qam16',variables{:});

% N - number of bits
% Ts - sample period
% S - average signal power for 16-qam
% overSampleSize - zero padding 
% overSampleSizeAnalog - digital to analog freq ratio

% transmit - before the DAC [1]
% transmit_analog - after the zero order hold (the DAC) [2]
% filtered_transmit_analog - after the reconstruction filter [3]
% received_analog - after the AWGN channel [4]
% filtered_recieved_analog - after the noise LPF [5]
% received_digital - after the zero decimator (the A/d) [6]


fs = 1/overSampleSize;     % Sample frequency (Hz)
fsa = 1/overSampleSizeAnalog; % Analog Sample freq (Hz)
% sampling array
fs_array = [fs, fsa, fsa, fsa, fsa, fs];

% cell array of signal vectors (since they have different lengths)
x = {transmit, transmit_analog, filtered_transmit_analog, ...
        received_analog, filtered_received_analog, received_digital};

% allocate storage arrays
%yMat = cell(6,1);
%powerMat = cell(6,1);
%leg = cell(6,1);
for i=1:6
    m = length(x{i});                   % Window length
    n = pow2(nextpow2(m));              % Transform length
    y = fft(x{i},n);                    % DFT
    f = (0:n-1)*(fs_array(i)/n);        % Frequency range (one-sided)
    power = y.*conj(y)/n;               % Power of the DFT
    
    y0 = fftshift(y);                           % Rearrange y values
    freqMat{i} = (-n/2:n/2-1)*(fs_array(i)/n);  % 0-centered  range
    avgPow = mean(y0.*conj(y0));                % Average power
    powerMat{i} = y0.*conj(y0)/n/avgPow;        % 0-centered power
    leg{i} = ['Waveform ', num2str(i)];         % legend entries
end

% group for plotting
plotGroup = [freqMat; powerMat];
% this allows us to have different length vectors in the cells and still
% throw it into plot without putting into a for loop, requiring holding and 
% the individual specifyication of colors (super annoying)

plot(plotGroup{:});
xlabel('Frequency (Hz)');
ylabel('Normalized Power');
title('{\bf 0-Centered Periodogram}');
%legend(leg{:},'Location','Best');

f = figure;
col = ['b','r','y','m','k','g'];
for i=1:6
    subplot(2,3,i);
    plot(freqMat{i},powerMat{i},col(i));
    xlabel('Frequency (Hz)');
    ylabel('Normalized Power');
    title(['Signal at Step ' num2str(i)]);
end
    