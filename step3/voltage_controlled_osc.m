function [output] = voltage_controlled_osc(input,delayed_input)

output = mod(2*moving_average(input,delayed_input),2*pi);

end

