function [output] = ZeroHoldDecimation(data,overSamplingRate,delay)
% FUNCTION 
%   this takes the input signal and the sampling factor to grab samples
%       according to the ratio
% INPUTS 
% data - the input signal waveform
% overSamplingRate - the number of samples to skip between points

% OUTPUTS
% output - the resulting downsampled waveform

for i = 1+delay:length(data)/overSamplingRate
   output(i-delay) = data((i-1)*overSamplingRate+1); 
end

end

