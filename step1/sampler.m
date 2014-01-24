function [output] = sampler(input_signal, overSamplingFactor, Ts)
%SAMPLER Summary of this function goes here
%   Detailed explanation goes here

N = length(input_signal);
output = zeros(1,N/overSamplingFactor);
for i=1:N/overSamplingFactor
    output(i) = input_signal((i-1)*overSamplingFactor*Ts+1);
end


end

