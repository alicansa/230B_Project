function [bits] = random_bit_generator(N)
%randomly generates given number of uniformly distributed bits 

bits_num = round(rand(1,N));
bits = '';

for i=1:N
  bits = strcat(bits,num2str(bits_num(i)));  
end


end

