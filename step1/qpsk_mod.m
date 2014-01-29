function [ sym_quad, sym_inp ] = qpsk_mod( bits, N )
% FUNCTION
%   convert the bits into symbols on qpsk scheme

% INPUTS
%   bits - the data input bitstream
%   N - the input binary datastream length

% OUTPUTS
%   sym_quad - the quadrature component of the symbol (sin)
%   sym_inp -  the in-phase component of the symbol (cos)

sym_quad = zeros(1,N);
sym_inp = zeros(1,N);

for i=1:N
    
    currentWord = bits((i-1)*2+1:i*2);
    
    switch currentWord
        
        case '00'
            sym_quad(i) = -1;
            sym_inp(i) = -1;
        case '01'
            sym_quad(i) = 1;
            sym_inp(i) = -1;
        case '10'
            sym_quad(i) = -1;
            sym_inp(i) = 1;
        case '11'
            sym_quad(i) = 1;
            sym_inp(i) = 1;
    end
end

end

