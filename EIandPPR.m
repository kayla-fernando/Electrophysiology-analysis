close all
clear all
clc

% Preprocessing: copy original .abf file, lowpass filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

% Load data
folder = 'folder'; %Naming conventions
run = 'run'; %Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
basepath = 'C:\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% Calculate amplitude, EI, and PPR for both EPSC and IPSC
avgEPSC = d(:,20); % Select EPSC summary sweep
avgIPSC = d(:,21); % Select IPSC summary sweep

% Adjust search window based on protocol params in Clampfit
search_1 = [0.633 0.650]; % search window in s for PSC1
search_2 = [0.733 0.750]; % search window in s for PSC2
Fs = 50000; % sampling rate in Hz

Estim1 = min(movmean(avgEPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % EPSC is a downward current, stim 1 range in samples, compare with Clampex protocol
Estim2 = min(movmean(avgEPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol

Istim1 = max(movmean(avgIPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % IPSC is an upward current, stim 1 range in samples, compare with Clampex protocol
Istim2 = max(movmean(avgIPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol

EI = -Estim1/Istim1;
ePPR = Estim2/Estim1;
iPPR = Istim2/Istim1;

allPPR = [Estim1 Estim2 Istim1 Istim2 EI ePPR iPPR];
