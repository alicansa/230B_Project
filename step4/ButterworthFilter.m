function [output] = ButterworthFilter(order,wc,data)
% FUNCTION - create and execute passing a signal through a butterworth
%   filter

% INPUTS
% order - the order is the number of poles in the transfer function
% wc - the normalized cuttoff freq
% data - the filter input waveform

% OUTPUTS
% output - the output from running the data through the BF

[b,a] = butter(order,wc);  % returns as [num, denom] of T.F
output = filter(b,a,data);
[h,w] = freqz(b,a);
% figure(4)
% plot(w,abs(h));


end

