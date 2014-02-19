function [output] = moving_average(input,input_delayed)

output = 0.5*input + 0.5*input_delayed;


end

