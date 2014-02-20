function [vco_output phase_acc_output] = voltage_controlled_osc(input,delayed_output)
phase_acc_output = phase_accumulator(input,delayed_output);
vco_output = mod(phase_acc_output,2*pi);

end

