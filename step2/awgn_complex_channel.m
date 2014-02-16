function [ channel_output ] = awgn_complex_channel(transmitted_sig,snr,S)
% FUNCTION
% this models WGN noise sequence added to the signal waveform

% INPUT
% transmitted_sig - the signal sent over the channel
% snr - the signal to noise ratio comparing noise and white noise variance
% S - the average symbol power 

% OUTPUT
% channel_output - the sum of input signal and the white noise

variance = S/(10^(snr/10));
noise = sqrt(variance/2)*randn(size(transmitted_sig)) + j*sqrt(variance/2)*randn(size(transmitted_sig));

channel_output = transmitted_sig + noise;
end


