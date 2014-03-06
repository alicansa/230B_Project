function [c_mmse] = MMSE_Equalizer_Train(trainerSequence,receivedSymbols,overSampleSize,L)
N = length(trainerSequence)/(2*L+1);
R = zeros(4*L+1,4*L+1);
p=zeros(1,4*L+1)';
for i=1:N
   receivedSymbol = receivedSymbols((i-1)*(2*L+1)+1:i*(2*L+1));
   tappedLineMatrix = toeplitz([receivedSymbol(end:-1:1),zeros(1,4*L+1-length(receivedSymbol(end:-1:1)))],...
                                   [receivedSymbol(1),zeros(1,2*L+1-1)]);
   R = R + tappedLineMatrix* ...
       conj(transpose(tappedLineMatrix));
   
   p = p + tappedLineMatrix* ...
            conj(trainerSequence((i-1)*(2*L+1)+1:i*(2*L+1)))';
end
   R = R*(1/N);
   p = p*(1/N);

c_mmse = inv(R)*p;
 
end

