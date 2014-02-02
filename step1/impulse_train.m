function [impulseTrain] = impulse_train(overSampleSize,N,symbols)
% FUNCTION
%   Take in the symbol signal and zero-pad to create a new data waveform

% INPUT
% overSampleSize - the number or zeros to pad
% N - the number of symbols transmitted
% symbols - the symbol waveform

% OUTPUT
% impulseTrain - the upsampled waveform


impulseTrain = zeros(1,length(symbols)*overSampleSize);

for i=1:N
   impulseTrain((i-1)*overSampleSize+1) = symbols(i);
end
end

