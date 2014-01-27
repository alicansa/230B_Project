function [bits] = bpsk_demod(sig)
% FUNCTION - this takes in the real and imaginary signals and maps
%               back into binary chips

% INPUTS
% inphase_sig - the real component of the incoming waveform

% OUTPUTS
% bits - the binary stream of data received

bits = '';
loopSize = length(sig);


for i=1:loopSize
   
    %decision based on regions of constellation
    
    if(sig(i) >= 0)
        bits = strcat(bits,'1');
        
    elseif(sig(i) < 0)
        bits = strcat(bits,'0');
    end    
    
end

end

