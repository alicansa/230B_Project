clear all
close all
clc

%COSTAS LOOP
%phase offset
phase_offsets = -2*pi:0.001:2*pi;
input = exp(j*phase_offsets);

im_sign = tanh(imag(input));
re_sign = tanh(real(input));
            
%phase error estimation
phase_estimate_costas = imag(input).*re_sign - real(input).*im_sign;
%plot s-curve
f=figure;
plot(phase_offsets,phase_estimate_costas);
xlabel('phase offset (rad)');
ylabel('Expected Value of Phase Detector Output');
print(f,'-djpeg','-r300','qpScurvepo_costas');

%DECISION DIRECTED
%phase offset
phase_offsets = -2*pi:0.001:2*pi;
input = exp(j*phase_offsets);

%demodulate
for i=1:length(phase_offsets)
    [bit,symbol] = qpsk_demod(real(input(i)),imag(input(i)));
    symbols(i) = symbol;
end
% come up with metric for phase error
phase_estimate_ddr = asin(imag(input.*conj(symbols))./(abs(input).*abs(symbols)));

%plot s-curve
f=figure;
plot(phase_offsets,phase_estimate_ddr);
xlabel('phase offset (rad)');
ylabel('Expected Value of Phase Detector Output');
print(f,'-djpeg','-r300','qpScurvepo_ddr');

%BOTH LOOPS
n=1
for t=1:0.1:10
   freq_offsets(n) = 10*t;
   n=n+1;
end

input = exp(j*freq_offsets);

% come up with metric for freq error
a = atan(imag(input)./real(input));
freq_estimate = diff(a)/0.1;

%plot s-curve
f=figure;
plot(freq_offsets(1:length(freq_offsets)-1),freq_estimate);
xlabel('carrier offset (Hz)');
ylabel('Expected Value of Frequency Detector Output');
print(f,'-djpeg','-r300','qpScurvefo');