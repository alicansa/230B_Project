function [real_output, imag_output] = phase_offset(phase,input)
% FUNCTION
%  Takes the signal and creates a phase offset error on it

% INPUT
% phase - the phase error
% input - the input waveform

% OUTPUT
% real_output - the resulting cosine component waveform 
% imag_output - the sine component waveform

output = exp(1i*phase)*input;
real_output = real(output);
imag_output = imag(output);
end

