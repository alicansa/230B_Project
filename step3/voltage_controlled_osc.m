function [vco_output phase_acc_output] = voltage_controlled_osc(input,delayed_output)

% INPUTS 
% input - the signal value presently
% delayed_outputs - the old value of the output
% OUTPUTS 
% vco_output - the VCO 

phase_acc_output = phase_accumulator(input,delayed_output);
%vco_output = mod(delayed_output,2*pi);
vco_output = mod(phase_acc_output,2*pi);
end

