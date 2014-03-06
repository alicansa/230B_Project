function [bits,symbol] =  qpsk_demod(inphase_sig,quadrature_sig)
% FUNCTION - this takes in the real and imaginary signals and maps
%               back into binary chips

% INPUTS
% inphase_sig - the real component of the incoming waveform
% quadrature_sig - the imaginary component of the waveform

% OUTPUTS
% bits - the binary stream of data received

bits = '';
loopSize = length(inphase_sig);
symbol = 0;

for i=1:loopSize
    
    %decision based on regions of constellation
    
    if(inphase_sig(i) >= 0)
        if (quadrature_sig(i) >= 0)
            bits = strcat(bits,'11');
            symbol = 1 + j; 
        elseif (quadrature_sig(i) < 0)
            bits = strcat(bits,'10');
            symbol = 1-j;
        end
    elseif(inphase_sig(i) < 0)
        if (quadrature_sig(i) >= 0)
            bits = strcat(bits,'01');
            symbol = -1+j;
        elseif (quadrature_sig(i) < 0)
            bits = strcat(bits,'00');
            symbol = -1-j;
        end 
    end 
end

