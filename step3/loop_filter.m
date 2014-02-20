function [output, delayed_sum] = loop_filter(input,delayed_sum_input)
%FUNCTION - this is a moving average filter

% INPUTS 
% input - the signal value presently
% delayed_sum_input - the previous value of the input

% OUTPUTS 
% output - the result (through the filter) output
% delayed sum - the new delayed sum

a = 1;  % the input tuning factors
b = 1;  % the tap factor

delayed_sum = delayed_sum_input + b*input;
output = a*input + delayed_sum;

end