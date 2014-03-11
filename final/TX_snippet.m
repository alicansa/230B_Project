%mapping symbols to signals by generating a impulse train and convolving
%with the srrc pulse
impulse_train_quad = impulse_train(overSampleSize,N/k,quadrature);
impulse_train_inphase = impulse_train(overSampleSize,N/k,inphase);
transmit = conv(impulse_train_inphase + j*impulse_train_quad,srrc,'same');
%digital to analog conversion
transmit_analog = ZeroHoldInterpolation(transmit,overSampleSizeAnalog/overSampleSize);
%anti aliasing filter
filtered_transmit_analog = ButterworthFilter(4,0.05,transmit_analog);