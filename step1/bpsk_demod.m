function [bits] = bpsk_demod(inphase_sig)
% FUNCTION - this takes in the real and imaginary signals and maps
%               back into binary chips

% INPUTS
% inphase_sig - the real component of the incoming waveform

% OUTPUTS
% bits - the binary stream of data received

bits = '';
loopSize = length(inphase_sig);


for i=1:loopSize
   
    %decision based on regions of constellation
    
    if(inphase_sig(i) >= 0)
        bits = strcat(bits,'1');
        
    elseif(inphase_sig(i) < 0)
        bits = strcat(bits,'0');
    end    
    
end

end

