function [c] = ZFEqualizer(h,L,overSampling)
%ZFEQUALIZER Summary of this function goes here
%   Detailed explanation goes here
h_coeff = downsample(h,overSampling);
N = length(h_coeff);


hM = toeplitz([h_coeff(end) zeros(1,L-1)],...
                [ h_coeff(N:-1:1) zeros(1,N+1)]);
            
e  = zeros(1,L);
e(ceil(L/2)) = 1;
c  = [pinv(hM)*e.'].';
%oversample 
c = upsample(c,overSampling);


end

