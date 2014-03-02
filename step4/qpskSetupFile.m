clear all;
close all;
clc;
% setup data for sensitivity analysis 
overSampleSize = 4;
overSampleSizeAnalog = 20; %80 times symbol rate
rollOffFactor = 0.25;
Ts = 1; %Symbol period
S=2; %average signal power for QPSK
B = rollOffFactor*(1/(2*Ts)) + 1/(2*Ts); %srrc pulse bandwidth
srrc = sqrt_raised_cosine(overSampleSize,rollOffFactor,400,Ts);
k = 2;  % bits per symbol
SNR = 20;
save('qpskSetup');