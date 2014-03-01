function [ output] = bandlimited_channel(h,data)
%BANDLIMITED_CHANNEL Summary of this function goes here
%   Detailed explanation goes here
output = conv(data,h);

end

