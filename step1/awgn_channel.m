function [channel_output] = awgn_channel(transmitted_sig,snr)
variance = 10^(-snr/10);
noise = sqrt(variance)*randn(size(transmitted_sig));

channel_output = transmitted_sig + noise;
end

