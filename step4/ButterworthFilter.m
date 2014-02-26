function [output] = ButterworthFilter(order,wc,data)
[b,a] = butter(order,wc);
output = filter(b,a,data);
end

