function [output] = ZeroHoldDecimation(data,overSamplingRate,delay)
for i = 1+delay:length(data)/overSamplingRate
   output(i-delay) = data((i-1)*overSamplingRate+1); 
end

end

