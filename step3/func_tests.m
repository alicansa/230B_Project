clear all;
close all;
clc

Ts = 1e-2;
n = 100;

t = 0:Ts:Ts*n-Ts;
f = 10;  %Hz
df = 2;  %Hz  offset
dp = pi/4;

y = sin(2*pi*f*t);
complex = exp(2*pi*1i*f*t + pi/4);
r_ExpPh = real(complex);
i_ExpPh = imag(complex);

[r_TrialPh, i_TrialPh] = phase_offset(pi/4,y);


plot(t, r_ExpPh, t, r_TrialPh);

