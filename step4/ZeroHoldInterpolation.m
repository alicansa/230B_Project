function [data_interp] = ZeroHoldInterpolation(data,overSampleRate)
data_interp = zeros(1,length(data));
for i =1:length(data)
   % data_interp((i-1)*overSampleRate+1:i*overSampleRate) = data((i-1)*overSampleRate+1);
   data_interp((i-1)*overSampleRate+1:i*overSampleRate) = data(i);
end

end

