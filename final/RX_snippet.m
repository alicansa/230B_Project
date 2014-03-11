%noise limiting filter
filtered_received_analog = ButterworthFilter(4,0.02,received_analog);
%analog to digital converter
received_digital = ZeroHoldDecimation(filtered_received_analog,overSampleSizeAnalog/overSampleSize,1);

%initialize feedback parameters
vco_output = 0;
phase_estimate = 0;
delayed_moving_av_input = 0;
delayed_vco_output = 0 ;
moving_av_input = 0;
phase_acc_output = 0;
delayed_moving_av_output = 0;
delayed_phase_acc_output = 0 ;

%Pass the received signal through the costas loop to get
%rid of the frequency offset
%pass symbol-by-symbol in order to simulate the feedback loop
for l=1:length(received_digital)
    
    delayed_moving_av_input = delayed_moving_av_output;
    delayed_phase_acc_output = phase_acc_output;
    
    %do correction
    corr_received(l) = exp(-j*vco_output)*received_digital(l);
    
    delayed_vco_output = vco_output;
    
    %seperate to real and imagenary parts
    im_received = real(corr_received(l));
    re_received = imag(corr_received(l));
    
    % gather the signs
    im_sign = tanh(im_received);
    re_sign = tanh(re_received);
    
    % come up with metric for phase error
    phase_estimate = -im_received*re_sign + re_received*im_sign;
    moving_av_input = phase_estimate;
    [moving_av_output delayed_moving_av_output] = loop_filter(moving_av_input,delayed_moving_av_input,0.05,0.001);
    
    loop_filter_output(l) = moving_av_output;
    
    %pass through VCO
    [vco_output phase_acc_output] = voltage_controlled_osc(moving_av_output,...
        delayed_phase_acc_output);
end

%pass the received signal through the matched filter for optimal
%detection
matched_output = conv(corr_received,srrc,'same');

%pass the matched filter output through the
% sampler to obtain symbols at each symbol period
sampled = sampler(matched_output,overSampleSize,Ts);

%Equalization
sampled_equalized = conv(sampled,c);
sampled_equalized = sampled_equalized((floor(L/2))+1:end-(floor(L/2)));
%pass the received symbols through ML-decision box
[output_bits,output_symbols] = qpsk_demod(real(sampled),...
    imag(sampled));