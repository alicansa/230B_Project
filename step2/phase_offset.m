function [output] = phase_offset(phase,input)
% FUNCTION
%  Takes the signal and creates a phase offset error on it

% INPUT
% phase - the phase error
% input - the input waveform

% OUTPUT


output = exp(1i*phase)*input;
end

