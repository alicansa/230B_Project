function [output] = ZeroHoldDecimation(data,overSamplingRate)
% FUNCTION 
%   this takes the input signal and the sampling factor to grab samples
%       according to the ratio
% INPUTS 
% data - the input signal waveform
% overSamplingRate - the number of samples to skip between points

% OUTPUTS
% output - the resulting downsampled waveform

for i = 1:length(data)/overSamplingRate
   output(i) = data((i-1)*overSamplingRate+floor(overSamplingRate/2)+1); 
end

end

