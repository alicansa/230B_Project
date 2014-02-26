x = 0:1000;
a = sinc(x);
a_filt = ButterworthFilter(4,0.2,a);
plot(abs(fft(a_filt)));