%initialize feedback parameters
vco_output = 0;
phase_estimate = 0;
delayed_moving_av_input = 0;
delayed_vco_output = 0 ;
moving_av_input = 0;
phase_acc_output = 0;
delayed_moving_av_output = 0;
delayed_phase_acc_output = 0 ;

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

    %pass through VCO
    [vco_output phase_acc_output] = voltage_controlled_osc(moving_av_output,...
        delayed_phase_acc_output);
end