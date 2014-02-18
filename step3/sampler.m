function [output] = sampler(input_signal, overSamplingFactor, Ts)
% FUNCTION - this takes the cts waveform and samples it 
%               (with upconversion) at periods of Ts
% INPUTS
% input_signal - the data stream received
% overSamplingFactor - the amount to over sample
% Ts - the symbol interval

% OUTPUTS
% output - the sampled data signal
N = length(input_signal);
output = zeros(1,N/overSamplingFactor);
for i=1:N/overSamplingFactor
    output(i) = input_signal((i-1)*overSamplingFactor+1);
end
end

