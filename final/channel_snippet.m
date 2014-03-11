%frequency offset
filtered_transmit_analog_offset = freq_offset(f_offset,...
        Ts,filtered_transmit_analog);
%bandlimited channel
h = zeros(1,2801);
h(1) = 0.1;
h(601) = 0.8;
h(1301) = 0.95;
h(2001) = 0.7;
h(2701) = 0.35;
L = 2701; % number of taps
c = ZFEqualizer(h,L); %construct the ZF equalizer

%pass through bandlimited channel
ISI_filtered_transmit_analog_offset = conv(filtered_transmit_analog_offset,...
                                        upsample(h,overSampleSizeAnalog));
                                        
ISI_filtered_transmit_analog_offset = ...
    ISI_filtered_transmit_analog_offset(overSampleSizeAnalog*...
                        1300+1:end-overSampleSizeAnalog*1301);

%pass the signals to be transmitted through awgn channel
    received_analog = awgn_complex_channel(filtered_transmit_analog_offset ...
        ,SNR,overSampleSizeAnalog/overSampleSize*S);