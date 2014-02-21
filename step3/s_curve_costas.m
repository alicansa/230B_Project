clear all
close all
clc

%phase offset costas
phase_offsets = -2*pi:0.001:2*pi;
input = exp(j*phase_offsets);

% gather the signs
im_sign = tanh(20*imag(input));
re_sign = tanh(20*real(input));
            
% come up with metric for phase error
phase_estimate_costas = imag(input).*re_sign - real(input).*im_sign;
figure
plot(phase_offsets,phase_estimate_costas);

%phase offset decision directed
phase_offsets = -2*pi:0.001:2*pi;
input = exp(j*phase_offsets);

%demodulate
for i=1:length(phase_offsets)
    [bit,symbol] = qpsk_demod(real(input(i)),imag(input(i)));
    symbols(i) = symbol;
end
% come up with metric for phase error
phase_estimate_ddr = asin(imag(input.*conj(symbols))./(abs(input).*abs(symbols)));
figure
plot(phase_offsets,phase_estimate_ddr);

%freq offset both
n=1
for t=1:0.1:10
   freq_offsets(n) = 10*t;
   n=n+1;
end

input = exp(j*freq_offsets);

% come up with metric for freq error
a = atan(imag(input)./real(input));
freq_estimate = diff(a)/0.1;
figure
plot(freq_offsets(1:length(freq_offsets)-1),freq_estimate);