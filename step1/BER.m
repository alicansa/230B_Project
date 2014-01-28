function [ber] = BER(input_bits,decoded_bits)
% FUNCTION
%   Take the input bits and compare to the recieved output bits, then 
%       divide by the total number of bits

% NOTE
% recall Probability_of_symb_error = BER*log2(K) where each symbol takes K
% bits

% INPUT
% input_bits - the input signal
% decoded_bits - the signal after the decoder

% OUTPUT
% ber - the bit error rate (lower is better)

loopSize = length(input_bits);
err = 0;
for i=1:loopSize
    if (~strcmp(input_bits(i),decoded_bits(i)))
        err = err + 1;
    end
end

ber = err/loopSize;

end

