function [output, delayed_sum] = loop_filter(input,delayed_sum_input,a,b)
%FUNCTION - this is a moving average filter

% INPUTS 
% input - the signal value presently
% delayed_sum_input - the previous value of the input
%a the input tuning factors
%b  the tap factor
 
% OUTPUTS 
% output - the result (through the filter) output
% delayed sum - the new delayed sum



delayed_sum = delayed_sum_input + b*input;
output = a*input + delayed_sum;

end