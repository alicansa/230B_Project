close all
clearvars
SNR = 0:13;

mmse_bpsk_1= [0.089089,0.0570,0.0420,0.0300,0.0150,0.00700,0.00280,0.00080,0.0002,0,0,0,0,0];
dfe_mmse_bpsk_1 = [0.0796,0.0582,0.0395,0.0248,0.0129,0.00598,0.00239,0.00079,0.000199,0,0,0,0,0];
zf_bpsk_1= [0.0990,0.0680,0.04604,0.03203,0.016016,0.00800,0.0030,0.00150,0.0005,0,0,0,0,0];
ne_bpsk_1 = [0.1001,0.0760,0.0550,0.0410,0.0280,0.0180,0.0080,0.0090,0.0060,0,0,0,0,0];
theo_bpsk_1= [0.0786,0.0562,0.0375,0.0228,0.0125,0.0059,0.0023,0.0007,0.00019,3.36272284196176e-05,3.87210821552205e-06,2.61306795357521e-07,9.00601035062878e-09,1.33293101753005e-10];

 h=figure;
    semilogy(SNR,zf_bpsk_1, '-ko');
    hold on;
    semilogy(SNR,mmse_bpsk_1, '-g+');
    semilogy(SNR,dfe_mmse_bpsk_1,'-mv');
    semilogy(SNR,ne_bpsk_1, '-rx');
    semilogy(SNR,theo_bpsk_1, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
    xlim([0 10]);
    ylim([10^-4 10^0]);
    legend('3 Tap ZF Equalized Simulation (Bit Error)', ...
        '3 Tap MMSE Equalized Simulation (Bit Error)',...
         '3 Tap DFE-MMSE Equalized Simulation (Bit Error)',...
         'Simulation (Bit Error)','Theory (Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','bpSNR1');

mmse_bpsk_2 = [0.080,0.06,0.04,0.02301,0.013,0.006,0.003,0.0009,0,0,0,0,0,0];
dfe_mmse_bpsk_2 = [0.0796,0.0572,0.0385,0.0238,0.0135,0.00599,0.0024,0.00075,0.000195,0,0,0,0,0];
zf_bpsk_2=   [0.0870,0.0640,0.04404,0.0250,0.0140,0.0063,0.0050,0.001,0,0,0,0,0,0]
theo_bpsk_2= [0.0786,0.0562,0.0375,0.0228,0.0125,0.0059,0.0023,0.0007,0.00019,3.36272284196176e-05,3.87210821552205e-06,2.61306795357521e-07,9.00601035062878e-09,1.33293101753005e-10];
ne_bpsk_2 =  [0.0910,0.0670,0.0570,0.0390,0.0260,0.0180,0.0080,0.0060,0.0030,0.0010,0,0,0,0];

 h=figure;
    semilogy(SNR,zf_bpsk_2, '-ko');
    hold on;
    semilogy(SNR,mmse_bpsk_2, '-g+');
    semilogy(SNR,dfe_mmse_bpsk_2,'-mv');
    semilogy(SNR,ne_bpsk_2, '-rx');
    semilogy(SNR,theo_bpsk_2, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
        xlim([0 10]);
    ylim([10^-4 10^0]);
    legend('5 Tap ZF Equalized Simulation (Bit Error)', ...
         '5 Tap DFE-MMSE Equalized Simulation (Bit Error)',...
        '5 Tap MMSE Equalized Simulation (Bit Error)','Simulation (Bit Error)','Theory (Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','bpSNR2');

mmse_bpsk_3= [0.07907,0.0565,0.0380,0.0230,0.0128,0.00600,0.003,0.00080,0,0,0,0,0,0];
dfe_mmse_bpsk_3 = [0.0796,0.0572,0.0385,0.0238,0.0135,0.00599,0.00239,0.00079,0.000199,0,0,0,0,0];
zf_bpsk_3= [0.08207,0.0570,0.040,0.02402,0.0130,0.00800,0.0038,00.001,0,0,0,0,0,0];
theo_bpsk_3= [0.0786,0.0562,0.0375,0.0228,0.0125,0.0059,0.0023,0.0007,0.00019,3.36272284196176e-05,3.87210821552205e-06,2.61306795357521e-07,9.00601035062878e-09,1.33293101753005e-10];
ne_bpsk_3 = [0.0960,0.0750,0.0640,0.0430,0.0210,0.0090,0.01301,0.0050,0.0080,0.0030,0,0,0,0];

 h=figure;
    semilogy(SNR,zf_bpsk_3, '-ko');
    hold on;
    semilogy(SNR,mmse_bpsk_3, '-g+');
    semilogy(SNR,dfe_mmse_bpsk_3,'-mv');
    semilogy(SNR,ne_bpsk_3, '-rx');
    semilogy(SNR,theo_bpsk_3, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
        xlim([0 10]);
    ylim([10^-4 10^0]);
    legend('3 Tap ZF Equalized Simulation (Bit Error)', ...
        '3 Tap DFE-MMSE Equalized Simulation (Bit Error)',...
        '3 Tap MMSE Equalized Simulation (Bit Error)','Simulation (Bit Error)','Theory (Bit Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','bpSNR3');

mmse_qpsk_1= [0.2921,0.24609,0.198,0.17086,0.1116,0.07683,0.0462,0.0272,0.0136,0.006,0.002,0,0.00,0.00];
dfe_mmse_qpsk_1 = [0.2941,0.2497,0.19923,0.1595,0.1089,0.0799,0.0494,0.02591,0.01199,0.004890,0,0,0,0];
zf_qpsk_1= [0.2961,0.2581,0.199,0.17486,0.11764,0.0804,0.0481,0.03321,0.01840,0.0072,0.0032,0.000,0.000,0.000];
theo_qpsk_1= [0.2921,0.2447,0.19723,0.1515,0.10979,0.0739,0.0454,0.02501,0.0119,0.004820,0.001564,0.000387,6.86040710628266e-05,7.93848103775288e-06];
ne_qpsk_1 = [0.30732,0.26130,0.2252,0.1660,0.1408,0.0940,0.06802,0.05442,0.02961,0.0136,0.00720,0.0020,0.0016,0.0008];

 h=figure;
    semilogy(SNR,zf_qpsk_1, '-ko');
    hold on;
    semilogy(SNR,mmse_qpsk_1, '-g+');
    semilogy(SNR,dfe_mmse_qpsk_1,'-mv');
    semilogy(SNR,ne_qpsk_1, '-rx');
    semilogy(SNR,theo_qpsk_1, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
        xlim([0 13]);
    ylim([10^-4 10^0]);
    legend('3 Tap ZF Equalized Simulation (Symbol Error)', ...
        '3 Tap DFE-MMSE Equalized Simulation (Symbol Error)',...
        '3 Tap MMSE Equalized Simulation (Symbol Error)','Simulation (Symbol Error)','Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','qpSNR1');

mmse_qpsk_2= [0.293715,0.2456,0.20448,0.1656,0.11964,0.07392,0.04522,0.02881,0.012806,0.005603,0.00170,0,0,0];
dfe_mmse_qpsk_2 = [0.2999,0.2449,0.19725,0.1516,0.10981,0.0741,0.0459,0.0259,0.0121,0.004890,0.001594,0,0,0];
zf_qpsk_2= [0.2997,0.2340,0.2080,0.1780,0.1244,0.07442,0.048819,0.03041,0.01440,0.0068,0.002,0,0,0];
theo_qpsk_2= [0.2921,0.2447,0.19723,0.1515,0.10979,0.0739,0.0454,0.02501,0.0119,0.004820,0.001564,0.000387,6.86040710628266e-05,7.93848103775288e-06];
ne_qpsk_2 = [0.31252,0.25130,0.2324,0.1824,0.1456,0.104041,0.075630,0.0548219,0.03441,0.020808,0.01240,0.00760,0.00320,0.00160];

 h=figure;
    semilogy(SNR,zf_qpsk_2, '-ko');
    hold on;
    semilogy(SNR,mmse_qpsk_2, '-g+');
    semilogy(SNR,dfe_mmse_qpsk_2,'-mv');
    semilogy(SNR,ne_qpsk_2, '-rx');
    semilogy(SNR,theo_qpsk_2, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
            xlim([0 13]);
    ylim([10^-4 10^0]);
    legend('5 Tap ZF Equalized Simulation (Symbol Error)', ...
        '5 Tap DFE-MMSE Equalized Simulation (Symbol Error)',...
        '5 Tap MMSE Equalized Simulation (Symbol Error)','Simulation (Symbol Error)','Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','qpSNR2');

mmse_qpsk_3= [0.29251,0.24049,0.19907,0.1545,0.112,0.0740,0.048019,0.0278,0.01300,0.0052,0.0022,0.00040,0,0];
dfe_mmse_qpsk_3 = [0.2928,0.245,0.1973,0.1519,0.10983,0.0741,0.0459,0.0252,0.0122,0.004826,0.00159,0,0,0];
zf_qpsk_3 = [0.2929,0.2492,0.20,0.1588,0.12004,0.07563,0.05002,0.02860,0.0150,0.0055,0.0024,0.00050,0,0];
theo_qpsk_3= [0.2921,0.2447,0.19723,0.1515,0.10979,0.0739,0.0454,0.02501,0.0119,0.004820,0.001564,0.000387,6.86040710628266e-05,7.93848103775288e-06];
ne_qpsk_3 =[0.3097,0.2725,0.2192,0.18487,0.14805,0.10844,0.07763,0.05562,0.03841,0.02440,0.0124,0.0044,0.0024,0];

 h=figure;
    semilogy(SNR,zf_qpsk_3, '-ko');
    hold on;
    semilogy(SNR,mmse_qpsk_3, '-g+');
    semilogy(SNR,dfe_mmse_qpsk_3,'-mv');
    semilogy(SNR,ne_qpsk_3, '-rx');
    semilogy(SNR,theo_qpsk_3, 'b');
    ylabel('Probability of Error');
    xlabel('SNR (dB)');
            xlim([0 13]);
    ylim([10^-4 10^0]);
    legend('3 Tap ZF Equalized Simulation (Symbol Error)', ...
        '3 Tap DFE-MMSE Equalized Simulation (Symbol Error)',...
        '3 Tap MMSE Equalized Simulation (Symbol Error)','Simulation (Symbol Error)','Theory (Symbol Error)','Location','SouthWest');
    % save the BER graph
    print(h,'-djpeg','-r300','qpSNR3');
