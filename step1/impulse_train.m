function [impulseTrain] = impulse_train(overSampleSize,N,symbols)
%IMPULSE_TRAIN 


impulseTrain = zeros(1,length(symbols)*overSampleSize);

for i=1:N
   impulseTrain((i-1)*overSampleSize+1) = symbols(i);
end


end

