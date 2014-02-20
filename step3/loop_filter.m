function [output delayed_sum] = loop_filter(input,delayed_sum_input)

delayed_sum = delayed_sum_input + 0.5*input;
output = 0.5*input + 0.5*delayed_sum;

end

