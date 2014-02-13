function [output] = phase_offset(phase,input)
output = exp(j*phase)*input;
end

