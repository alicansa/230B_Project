function [output] = phase_accumulator(input,delayed_input_sum)
% FUNCTION - this accumulates (sums) 

% INPUTS 
% input - current signal
% delayed_input_sum - sum of previous signal

% OUTPUTS
% output - new sum

output = delayed_input_sum + input;

end

