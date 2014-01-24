function [bits] = random_bit_generator(N)
%FUNCTION - randomly generates given number of uniformly distributed bits

% INPUTS
% N - number of bits to make
% OUTPUTS
% bits - the random set of bits generated

bits_num = round(rand(1,N));
bits = '';

for i=1:N
  bits = strcat(bits,num2str(bits_num(i)));  
end
end

