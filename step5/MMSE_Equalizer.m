function [c] = MMSE_Equalizer(h,No,L)
N = length(h);
   
hM = toeplitz([h(ceil(N/2):1:N) zeros(1,L-length(h(ceil(N/2):1:N)))],...
     [h(ceil(N/2):-1:1) zeros(1,L-length(h(ceil(N/2):-1:1)))]);
e  = zeros(1,L);
e(ceil(L/2)) = 1;
c = ((inv(transpose(hM)*hM + eye(N,N)*No)*transpose(hM))*e')';
end

