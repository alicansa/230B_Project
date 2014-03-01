function [c] = ZFEqualizer(h,L)
%ZFEQUALIZER Summary of this function goes here
%   Detailed explanation goes here
k = 1;
hM = toeplitz([h([2:end]) zeros(1,2*k+1-L+1)], [ h([2:-1:1]) zeros(1,2*k+1-L+1) ]);
e  = zeros(1,2*k+1);
e(k+1) = 1;
c  = [pinv(hM)*e.'].';

end

