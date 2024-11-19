%% REMEMBER PATH CHANGES%%

% Edited by Kayla Fernando (11/19/24)

close all
clear all
clc 

% Assumes using original recordings from Clampex
folder = 'folder'; % Naming conventions
run = 'run'; % Clampex ABF naming conventions
basepath = 'Z:\\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Calculate holding current for all EPSC sweeps and all IPSC sweeps %%

% Select all EPSC sweeps
allEPSC = d(:,1:10);
% Select all IPSC sweeps
allIPSC = d(:,11:20); 

baseline_search = [0.001 0.100]; % search window in s
Fs = 50000; % sampling rate in Hz

for ii = 1:size(allEPSC,2)
    baselineEPSC(ii) = mean(allEPSC((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
end
for ii = 1:size(allIPSC,2)
    baselineIPSC(ii) = mean(allIPSC((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
end

avgIholdEPSC = mean(baselineEPSC)
avgIholdIPSC = mean(baselineIPSC)
