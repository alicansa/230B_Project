function [sym_quad sym_inp] = QAM_16_mod(bits,N)
% FUNCTION
%   convert the bits into symbols on QAM16 scheme

% INPUTS
%   bits - the data input bitstream
%   N - 

% OUTPUTS
%   sym_quad - the quadrature component of the symbol
%   sym_inp -  the in-phase component of the symbol


sym_quad = zeros(1,N);
sym_inp = zeros(1,N);

for i=1:N
   
    currentWord = bits((i-1)*4+1:i*4);
    
    switch currentWord
        
        case '0000'
            sym_quad(i) = 3;
            sym_inp(i) = -3;          
        case '0001'
            sym_quad(i) = 1;
            sym_inp(i) = -3;           
        case '0010'
            sym_quad(i) = -3; 
            sym_inp(i) = -3;           
        case '0011'
            sym_quad(i) = -1; 
            sym_inp(i) = -3 ;           
        case '0100'
            sym_quad(i) = 3;
            sym_inp(i) =  -1;          
        case '0101'
            sym_quad(i) = 1;
            sym_inp(i) =  -1;         
        case '0110'
            sym_quad(i) = -3;
            sym_inp(i) =  -1;           
        case '0111'
            sym_quad(i) = -1;
            sym_inp(i) =  -1;           
        case '1000'
            sym_quad(i) = 3;
            sym_inp(i) = 3;            
        case '1001'
            sym_quad(i) = 1;
            sym_inp(i) = 3;           
        case '1010'
            sym_quad(i) = -3;
            sym_inp(i) = 3;           
        case '1011'
            sym_quad(i) = -1;
            sym_inp(i) = 3;
        case '1100'
            sym_quad(i) = 3; 
            sym_inp(i) = 1;
        case '1101'
            sym_quad(i) = 1;
            sym_inp(i) = 1;
        case '1110'
            sym_quad(i) = -3;
            sym_inp(i) = 1; 
        case '1111'
            sym_quad(i) = -1;
            sym_inp(i) = 1;
            
    end
    
end


end

