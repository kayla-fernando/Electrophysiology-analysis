%% REMEMBER PATH CHANGES %%

% Calculating decay time constant of evoked currents by fitting a single exponential function

% Written by Kayla Fernando (11/10/22)

close all
clear all
clc

folder = 'KF_211011_analyzed'; % Naming conventions
run = '211011000 - Copy - analyzed - all traces'; % Naming conventions
basepath = 'C:\\users\kdf25\Documents\Molecular Devices\pCLAMP\Data\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information
clc

sweep = 36; % summary sweep
search = [0.880 1]; % search window in s for PSC2
Fs = 50000; % sampling rate in Hz

event = d((Fs*search(1)):(Fs*search(2)),sweep); % include peak amplitude and enough baseline

start = find(event == min(event)); % for EPSCs
%start = find(event == max(event)); % for IPSCs
event = event(start:end);
[fitObject,gof] = fit([1:numel(event)]',event,'exp1')
plot(fitObject,[1:numel(event)]',event);

tau = 1/fitObject.b % in samples
tau = tau/Fs % in s

[tau gof.rsquare];
