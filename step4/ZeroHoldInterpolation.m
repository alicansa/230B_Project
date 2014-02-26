function [data_interp] = ZeroHoldInterpolation(data,overSampleRate)

for i =1:length(data)
    data_interp((i-1)*overSampleRate+1:i*overSampleRate) = data(i);
end

end

