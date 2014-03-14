function [c] = ZFEqualizer(h,L)
% this function takes in a channel and window size and gives a TF

% INPUTS 
%   h - the channel model
%   L - the window size of the filter
% OUTPUTS
%   c - the tap coefficients

N = length(h);
   
hM = toeplitz([h(ceil(N/2):1:N) zeros(1,L-length(h(ceil(N/2):1:N)))],...
     [h(ceil(N/2):-1:1) zeros(1,L-length(h(ceil(N/2):-1:1)))]);
            
e  = zeros(1,L);
e(ceil(L/2)) = 1;
c  = [pinv(hM)*e']';

end

