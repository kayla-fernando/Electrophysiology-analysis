%% REMEMBER PATH CHANGES %%

close all
clear all
clc

% Preprocessing: copy original .abf file, filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

% Load data
folder = 'KF_210812_analyzed'; %Naming conventions
run = '21812001 - Copy - analyzed - all traces - 1'; %Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
basepath = 'C:\Users\kdf25\Documents\Molecular Devices\pCLAMP\Data\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% Calculate PPR for both EPSC and IPSC
avgEPSC = d(:,47); % Select EPSC summary sweep
avgIPSC = d(:,48); % Select IPSC summary sweep

search_1 = [0.757 0.800]; % search window in ms for PSC1
search_2 = [0.857 0.900]; % search window in ms for PSC2
Fs = 50000; % sampling rate in Hz

Estim1 = min(movmean(avgEPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % EPSC is a downward current, stim 1 range in samples, compare with Clampex protocol
Estim2 = min(movmean(avgEPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol

Istim1 = max(movmean(avgIPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % IPSC is an upward current, stim 1 range in samples, compare with Clampex protocol
Istim2 = max(movmean(avgIPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol

EI = -Estim1/Istim1;
ePPR = Estim2/Estim1;
iPPR = Istim2/Istim1;

allPPR = [Estim1 Estim2 Istim1 Istim2 EI ePPR iPPR];