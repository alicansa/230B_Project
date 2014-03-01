function [output_data] = channel_2(data,overSampleSize)
%h(t) = delta(t) - 0.25*delta(t-Ts) + 0.12*delta(t-2Ts)
output_data = data;
for i =overSampleSize+1:length(data)
    output_data(i) = output_data(i) - 0.25*data(i-overSampleSize);
end

for i =2*overSampleSize+1:length(data)
    output_data(i) = output_data(i) +  0.125*data(i-2*overSampleSize);
end

end

