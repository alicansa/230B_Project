function [impulseTrain] = impulse_train(overSampleSize,N,symbols)
%IMPULSE_TRAIN 


impulseTrain = zeros(1,N);

for i=1:N/4
   impulseTrain((i-1)*overSampleSize+1) = symbols(i);
end


end

