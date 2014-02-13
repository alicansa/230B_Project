function [ sym ] = bpsk_mod( bits, N )
% FUNCTION
%   convert the bits into symbols on bpsk scheme

% INPUTS
%   bits - the data input bitstream
%   N - the number of symbols to make

% OUTPUTS
%   sym - the symbol stream after modulation

sym = zeros(1,N);
for i=1:N  
    currentWord = bits(i);  
    switch currentWord     
        case '0'
            sym(i) = -1;
        case '1'
            sym(i) = 1;
    end
end
end

