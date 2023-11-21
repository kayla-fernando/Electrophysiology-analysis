%% REMEMBER PATH CHANGES %%

close all
clear all
clc

% Preprocessing: copy original .abf file, filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

% Load data
folder = 'KF_231110_analyzed'; %Naming conventions
run = '231110_0002 - Copy - analyzed - all traces'; %Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
basepath = 'Y:\\home\kayla\Electrophysiology analysis\ChR2 in MF opto stim\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

avgEPSC = d(:,54); % Select EPSC summary sweep
avgIPSC = d(:,55); % Select IPSC summary sweep

search_1 = [0.318 0.348]; % search window in s 
search_2 = [0.418 0.448]; 
search_3 = [0.518 0.548];
Fs = 50000; % sampling rate in Hz

opto_Estim1 = min(movmean(avgEPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % Stim 1 range in samples, compare with Clampex protocol
opto_Estim2 = min(movmean(avgEPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol
opto_Estim3 = min(movmean(avgEPSC((Fs*search_3(1)):(Fs*search_3(2))),101)); % Stim 3 range in samples, compare with Clampex protocol

opto_Istim1 = max(movmean(avgIPSC((Fs*search_1(1)):(Fs*search_1(2))),101)); % Stim 1 range in samples, compare with Clampex protocol
opto_Istim2 = max(movmean(avgIPSC((Fs*search_2(1)):(Fs*search_2(2))),101)); % Stim 2 range in samples, compare with Clampex protocol
opto_Istim3 = max(movmean(avgIPSC((Fs*search_3(1)):(Fs*search_3(2))),101)); % Stim 3 range in samples, compare with Clampex protocol

opto_Eamps = [opto_Estim1 opto_Estim2 opto_Estim3]
opto_Iamps = [opto_Istim1 opto_Istim2 opto_Istim3]
EI = -opto_Estim1/opto_Istim1
ePPR = opto_Estim2/opto_Estim1