close all;
clear all;
overSampleSize = 4;
rollOffFactor = 0.1;
Ts = 1;

%%squareroot raised cosine test
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,10,Ts);
stem(srrc);
figure
stem(conv(srrc,srrc,'same'));
