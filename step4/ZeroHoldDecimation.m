function [output] = ZeroHoldDecimation(data,overSamplingRate)

for i = 1:length(data)/overSamplingRate
   output(i) = data((i-1)*overSamplingRate+floor(overSamplingRate/2)+1); 
end

end

