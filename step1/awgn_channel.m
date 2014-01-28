function [channel_output] = awgn_channel(transmitted_sig,snr)
% FUNCTION - this models WGN noise sequence added to the signal waveform

% INPUT
% transmitted_sig - the signal sent over the channel
% snr - the signal to noise ratio comparing noise and white noise variance

% OUTPUT
% channel_output - the sum of input signal and the white noise

variance = 10^(-snr/10);
noise = sqrt(variance)*randn(size(transmitted_sig));

channel_output = transmitted_sig + noise;
end

