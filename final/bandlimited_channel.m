function [output] = bandlimited_channel(h,data)
% this function sends the data through a channel that is bandlimited

% INPUTS 
%   h - the channel 
%   data - the input waveform
% OUTPUTS
%   output - the bandlimited response

output = conv(data,h);
end

