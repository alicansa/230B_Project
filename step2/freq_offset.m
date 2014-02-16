function [ output ] = freq_offset( freq, Ts, input )
% FUNCTION
%  Takes the signal and creates a phase offset error on it

% INPUT
% freq - the frequency offset error
% Ts - the sample interval
% input - the input waveform

% OUTPUT
% output - the resulting waveform

n = length(input); % find signal window size
time = 0:Ts:Ts*n-Ts;  % create a time vector
output = exp(1i*freq*time).*input;

end

