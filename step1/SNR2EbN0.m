
function [EbN0] = SNR2EbN0(SNR,symbolSize,B)
% FUNCTION
% this takes a given SNR ratio (in dB) and translates it into equivelant
%   Eb/No values

% INPUTS
% SNR - the db signal to noise ratio
% symbolSize - the number of bits per symbol

% OUTPUTS
% EbN0 - the bit power over noise power

EbN0 = SNR - 10*log10(symbolSize/B);

end

