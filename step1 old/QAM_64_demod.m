function [bits] = QAM_64_demod(inphase_sig,quadrature_sig)
% FUNCTION - this takes in the real and imaginary signals and maps
%               back into binary chips

% INPUTS
% inphase_sig - the real component of the incoming waveform
% quadrature_sig - the imaginary component of the waveform

% OUTPUTS
% bits - the binary stream of data received

bits = '';
loopSize = length(inphase_sig);


for i=1:loopSize
   
    %decision
    
    if(quadrature_sig(i) >= 6)
       
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'000000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'000001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'000011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'000010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'000110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'000111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'000101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'000100'); 
        end
         
    elseif(quadrature_sig(i) >= 4 && quadrature_sig(i) < 6)
       
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'001000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'001001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'001011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'001010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'001110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'001111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'001101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'001100'); 
        end
        
    elseif (quadrature_sig(i) >= 2 && quadrature_sig(i) < 4)
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'011000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'011001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'011011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'011010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'011110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'011111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'011101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'011100'); 
        end
        
    elseif (quadrature_sig(i) >= 0 && quadrature_sig(i) < 2 )
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'010000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'010001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'010011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'010010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'010110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'010111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'010101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'010100'); 
        end
        
    elseif(quadrature_sig(i) < 0 && quadrature_sig(i) >= -2)
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'110000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'110001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'110011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'110010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'110110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'110111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'110101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'110100'); 
        end
         
    elseif(quadrature_sig(i) < -2 && quadrature_sig(i) >= -4)
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'111000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'111001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'111011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'111010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'111110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'111111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'111101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'111100'); 
        end 
         
    elseif(quadrature_sig(i) < -4 && quadrature_sig(i) >= -6)
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'101000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'101001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'101011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'101010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'101110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'101111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'101101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'101100'); 
        end
        
     elseif(quadrature_sig(i) < -6)
        
        if (inphase_sig(i) <= -6)
           bits = strcat(bits,'100000');
        elseif (inphase_sig(i) > -6 && inphase_sig(i) <= -4)
           bits = strcat(bits,'100001');
        elseif (inphase_sig(i) > -4 && inphase_sig(i) <= -2)
           bits = strcat(bits,'100011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) <= 0)
           bits = strcat(bits,'100010');
        elseif (inphase_sig(i) > 0 && inphase_sig(i) <= 2)
           bits = strcat(bits,'100110'); 
        elseif (inphase_sig(i) > 2 && inphase_sig(i) <= 4)
           bits = strcat(bits,'100111'); 
        elseif (inphase_sig(i) > 4 && inphase_sig(i) <= 6)
           bits = strcat(bits,'100101'); 
        elseif (inphase_sig(i) > 6 )
           bits = strcat(bits,'100100'); 
        end    
        
    end
    
    
end


end

