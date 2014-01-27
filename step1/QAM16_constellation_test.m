
%%16-QAM constallation test
bits_16 = '0000000100100011010001010110011110001001101010111100110111101111';
N= length(bits_16)/4;
[quadrature_16 inphase_16] = QAM_16_mod(bits_16,N);
scatterplot(quadrature_16+j*inphase_16);
test_decode_16 = QAM_16_demod(inphase_16,quadrature_16);
test_ber_16 = BER(bits_16,test_decode_16);