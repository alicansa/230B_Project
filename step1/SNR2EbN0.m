function [EbN0] = SNR2EbN0(SNR,symbolSize)

EbN0 = SNR - 10*log10(symbolSize);

end

