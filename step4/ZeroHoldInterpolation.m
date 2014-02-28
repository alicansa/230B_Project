function [data_interp] = ZeroHoldInterpolation(data,overSampleRate)
% FUNCTION 
%   this takes the input signal and, the input factor, holds at the 
%       input level for m sample
% INPUTS 
% data - the input signal waveform
% overSampleRate - the factor, or number of holds, for each input point

% OUTPUTS
% data_interp - the resulting upsampled waveform

for i =1:length(data)
    data_interp((i-1)*overSampleRate+1:i*overSampleRate) = data(i);
end

end

