function [bits] = QAM_16_demod(inphase_sig,quadrature_sig)
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
   
    %decision based on regions of constellation
    
    if(quadrature_sig(i) >= 2)
       
        if (inphase_sig(i) <= -2)
           bits = strcat(bits,'0000');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) < 0)
           bits = strcat(bits,'0100');
        elseif (inphase_sig(i) >= 0 && inphase_sig(i) < 2)
           bits = strcat(bits,'1100'); 
        elseif (inphase_sig(i) >= 2 )
           bits = strcat(bits,'1000'); 
        end
        
    elseif (quadrature_sig(i) >= 0 && quadrature_sig(i) < 2)
        
        if (inphase_sig(i) <= -2)
           bits = strcat(bits,'0001');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) < 0)
           bits = strcat(bits,'0101');
        elseif (inphase_sig(i) >= 0 && inphase_sig(i) < 2)
           bits = strcat(bits,'1101'); 
        elseif (inphase_sig(i) >= 2 )
           bits = strcat(bits,'1001'); 
        end
        
    elseif (quadrature_sig(i) < 0 && quadrature_sig(i) >= -2 )
        
         if (inphase_sig(i) <= -2)
           bits = strcat(bits,'0011');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) < 0)
           bits = strcat(bits,'0111');
        elseif (inphase_sig(i) >= 0 && inphase_sig(i) < 2)
           bits = strcat(bits,'1111'); 
        elseif (inphase_sig(i) >= 2 )
           bits = strcat(bits,'1011'); 
        end
        
    elseif(quadrature_sig(i) < -2)
        
        if (inphase_sig(i) <= -2)
           bits = strcat(bits,'0010');
        elseif (inphase_sig(i) > -2 && inphase_sig(i) < 0)
           bits = strcat(bits,'0110');
        elseif (inphase_sig(i) >= 0 && inphase_sig(i) < 2)
           bits = strcat(bits,'1110'); 
        elseif (inphase_sig(i) >= 2 )
           bits = strcat(bits,'1010'); 
         end
    end
    
    
end





end

