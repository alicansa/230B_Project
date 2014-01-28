function [EbN0] = SNR2EbN0(SNR,Rb,BW,No)
% FUNCTION
% this will convert SNR values into equivelant Eb/No

%INPUTS
% SNR - the signal to noise ratio
% Rb - bit rate
% BW - BW of the noise 
% N0 - Noise Power

% OUTPUTS
% EbNo

EbN0 = SNR*BW*No/Rb;

end

