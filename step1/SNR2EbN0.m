function [EbN0] = SNR2EbN0(SNR,symbolSize,B)

EbN0 = SNR - 10*log10(symbolSize/B);

end

