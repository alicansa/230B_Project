function [ber] = BER(input_bits,decoded_bits)
%BER Summary of this function goes here
%   Detailed explanation goes here

loopSize = length(input_bits);
ber = 0;
for i=1:loopSize
    if (~strcmp(input_bits(i),decoded_bits(i)))
        ber = ber + 1;
    end
end

ber = ber/loopSize;

end

