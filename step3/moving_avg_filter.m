function [output, delayed_sum] = moving_avg_filter(input,delayed_sum_input)
%FUNCTION - 

% INPUTS 
% input - the signal value presently
% delayed_sum_input - the previous value of the input

% OUTPUTS 
% output - the result (through the filter) output
% delayed sum - the new delayed sum

a = .5;  % the input tuning factors
b = .5;  % the tap factor

delayed_sum = delayed_sum_input + b*input;
output = a*input + b*delayed_sum;

end