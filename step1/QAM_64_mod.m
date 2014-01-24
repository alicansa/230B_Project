function [sym_quad sym_inp] = QAM_64_mod(bits,N)
%QAM_64_MOD Summary of this function goes here
%   Detailed explanation goes here

% INPUTS
%   bits - the data input bitstream
%   N - 

% OUTPUTS
%   sym_quad - the quadrature component of the symbol
%   sym_inp -  the in-phase component of the symbol

sym_quad = zeros(1,N);
sym_inp = zeros(1,N);

for i=1:N
   
    currentWord = bits((i-1)*6+1:i*6);
    
    switch currentWord
        
        case '000000'
            sym_quad(i) = 7;
            sym_inp(i) = -7;          
        case '000001'
            sym_quad(i) = 7;
            sym_inp(i) = -5;           
        case '000010'
            sym_quad(i) = 7; 
            sym_inp(i) = -1;           
        case '000011'
            sym_quad(i) = 7; 
            sym_inp(i) =  -3;           
        case '000100'
            sym_quad(i) = 7;
            sym_inp(i) =  7;          
        case '000101'
            sym_quad(i) = 7;
            sym_inp(i) =  5;         
        case '000110'
            sym_quad(i) = 7;
            sym_inp(i) = 1;           
        case '000111'
            sym_quad(i) = 7;
            sym_inp(i) =  3;           
        case '001000'
            sym_quad(i) = 5;
            sym_inp(i) = -7;            
        case '001001'
            sym_quad(i) = 5;
            sym_inp(i) = -5;           
        case '001010'
            sym_quad(i) = 5;
            sym_inp(i) = -1;           
        case '001011'
            sym_quad(i) = 5;
            sym_inp(i) = -3;
        case '001100'
            sym_quad(i) = 5; 
            sym_inp(i) = 7;
        case '001101'
            sym_quad(i) = 5;
            sym_inp(i) = 5;
        case '001110'
            sym_quad(i) = 5;
            sym_inp(i) = 1; 
        case '001111'
            sym_quad(i) = 5;
            sym_inp(i) = 3; 
        case '010000'
            sym_quad(i) = 1;
            sym_inp(i) = -7;          
        case '010001'
            sym_quad(i) = 1;
            sym_inp(i) = -5;           
        case '010010'
            sym_quad(i) = 1; 
            sym_inp(i) = -1;           
        case '010011'
            sym_quad(i) = 1; 
            sym_inp(i) =  -3;           
        case '010100'
            sym_quad(i) = 1;
            sym_inp(i) =  7;          
        case '010101'
            sym_quad(i) = 1;
            sym_inp(i) =  5;         
        case '010110'
            sym_quad(i) = 1;
            sym_inp(i) =  1;           
        case '010111'
            sym_quad(i) = 1;
            sym_inp(i) =  3;           
        case '011000'
            sym_quad(i) = 3;
            sym_inp(i) = -7;            
        case '011001'
            sym_quad(i) = 3;
            sym_inp(i) = -5;           
        case '011010'
            sym_quad(i) = 3;
            sym_inp(i) = -1;           
        case '011011'
            sym_quad(i) = 3;
            sym_inp(i) = -3;
        case '011100'
            sym_quad(i) = 3; 
            sym_inp(i) = 7;
        case '011101'
            sym_quad(i) = 3;
            sym_inp(i) = 5;
        case '011110'
            sym_quad(i) = 3;
            sym_inp(i) = 1; 
        case '011111'
            sym_quad(i) = 3;
            sym_inp(i) = 3;
        case '100000'
            sym_quad(i) = -7;
            sym_inp(i) = -7;          
        case '100001'
            sym_quad(i) = -7;
            sym_inp(i) = -5;           
        case '100010'
            sym_quad(i) = -7; 
            sym_inp(i) = -1;           
        case '100011'
            sym_quad(i) = -7; 
            sym_inp(i) =  -3;           
        case '100100'
            sym_quad(i) = -7;
            sym_inp(i) =  7;          
        case '100101'
            sym_quad(i) = -7;
            sym_inp(i) =  5;         
        case '100110'
            sym_quad(i) = -7;
            sym_inp(i) = 1;           
        case '100111'
            sym_quad(i) = -7;
            sym_inp(i) =  3;           
        case '101000'
            sym_quad(i) = -5;
            sym_inp(i) = -7;            
        case '101001'
            sym_quad(i) = -5;
            sym_inp(i) = -5;           
        case '101010'
            sym_quad(i) = -5;
            sym_inp(i) = -1;           
        case '101011'
            sym_quad(i) = -5;
            sym_inp(i) = -3;
        case '101100'
            sym_quad(i) = -5; 
            sym_inp(i) = 7;
        case '101101'
            sym_quad(i) = -5;
            sym_inp(i) = 5;
        case '101110'
            sym_quad(i) = -5;
            sym_inp(i) = 1; 
        case '101111'
            sym_quad(i) = -5;
            sym_inp(i) = 3; 
        case '110000'
            sym_quad(i) = -1;
            sym_inp(i) = -7;          
        case '110001'
            sym_quad(i) = -1;
            sym_inp(i) = -5;           
        case '110010'
            sym_quad(i) = -1; 
            sym_inp(i) = -1;           
        case '110011'
            sym_quad(i) = -1; 
            sym_inp(i) =  -3;           
        case '110100'
            sym_quad(i) = -1;
            sym_inp(i) =  7;          
        case '110101'
            sym_quad(i) = -1;
            sym_inp(i) =  5;         
        case '110110'
            sym_quad(i) = -1;
            sym_inp(i) =  1;           
        case '110111'
            sym_quad(i) = -1;
            sym_inp(i) =  3;           
        case '111000'
            sym_quad(i) = -3;
            sym_inp(i) = -7;            
        case '111001'
            sym_quad(i) = -3;
            sym_inp(i) = -5;           
        case '111010'
            sym_quad(i) = -3;
            sym_inp(i) = -1;           
        case '111011'
            sym_quad(i) = -3;
            sym_inp(i) = -3;
        case '111100'
            sym_quad(i) = -3; 
            sym_inp(i) = 7;
        case '111101'
            sym_quad(i) = -3;
            sym_inp(i) = 5;
        case '111110'
            sym_quad(i) = -3;
            sym_inp(i) = 1; 
        case '111111'
            sym_quad(i) = -3;
            sym_inp(i) = 3;
    end
    
end

end

