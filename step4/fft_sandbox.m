close all;
clear all;
clc;

fs = 100;                          % Sample frequency (Hz)
t = 0:1/fs:10-1/fs;                % 10 sec sample
x = (1.3)*sin(2*pi*15*t) ...       % 15 Hz component
  + (1.7)*sin(2*pi*40*(t-2)) ...   % 40 Hz component
  + (2.5)*randn(size(t));          % Gaussian noise;


m = length(x);          % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(x,n);           % DFT
f = (0:n-1)*(fs/n);     % Frequency range
power = y.*conj(y)/n;   % Power of the DFT

y0 = fftshift(y);          % Rearrange y values
f0 = (-n/2:n/2-1)*(fs/n);  % 0-centered frequency range
power0 = y0.*conj(y0)/n;   % 0-centered power

plot(f0,power0)
xlabel('Frequency (Hz)')
ylabel('Power')
title('{\bf 0-Centered Periodogram}')