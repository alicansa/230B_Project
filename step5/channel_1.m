function [output_data] = channel_1(data,overSampleSize)
%h(t) = delta(t) + 0.25*delta(t-Ts)
output_data = data;
for i =overSampleSize+1:length(data)
    output_data(i) = output_data(i) + 0.25*data(i-overSampleSize);
end
end

