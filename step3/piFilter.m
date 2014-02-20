function [output] = piFilter(input,delayed_input)
%FUNCTION - 

% INPUTS 
% input - the signal value presently
% delayed_input - the previous value of the input

% OUTPUTS 
% output - the result (through the filter) output

a = .5;  % the input tuning factors
b = .5;  % the tap factor

output = a*input + b*delayed_input;

end