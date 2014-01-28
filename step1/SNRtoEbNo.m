function EbNo = SNRtoEbNo(SNR,Rb,BW,No)
% FUNCTION
% this will convert SNR values into equivelant Eb/No

%INPUTS
% SNR - the signal to noise ratio
% Rb - bit rate
% BW - BW of the noise 
% N0 - Noise Power

% OUTPUTS
% EbNo

EbNo = SNR*BW*No/Rb;
