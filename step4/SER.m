function [ser] = SER(input_bits,decoded_bits,symbol_length)
loopSize = length(input_bits);
ser = 0;
for i=1:loopSize/symbol_length
    if (~strcmp(input_bits((i-1)*symbol_length+1:i*symbol_length),decoded_bits((i-1)*symbol_length+1:i*symbol_length)))
        ser = ser + 1;
    end
end
ser = ser/(loopSize/symbol_length);
end

