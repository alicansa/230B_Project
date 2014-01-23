function [sym_quad sym_inp] = QAM_16_mod(bits,N)
%QAM_16_MOD Summary of this function goes here
%   Detailed explanation goes here


%check if the number of bits are multiple of four
%if not pad zero to the end

sym_quad = zeros(1,N);
sym_inp = zeros(1,N);
index =0;
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

