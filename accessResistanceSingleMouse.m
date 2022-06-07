% Edited by Kayla Fernando (5/4/22)

close all
clear all
clc

%% Load data %%

% Preprocessing: copy original .abf file, filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

folder = 'KF_210720_analyzed'; % Naming conventions
run = '21720000 - Copy - analyzed - all traces'; % Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
file = 21720000;
basepath = 'C:\Users\kayla\My Documents\Molecular Devices\pCLAMP\Data\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Calculate access resistance for all EPSC sweeps and all IPSC sweeps %%

% Select all EPSC sweeps
allEPSC = d(:,1:10); 
% Select all IPSC sweeps
allIPSC = d(:,25:45); 

[RaEPSC,allaccessEPSC] = access(allEPSC);
[RaIPSC,allaccessIPSC] = access(allIPSC);

% Calculate 10-90% rise time in Clampfit w/ search region from 756.5 to 800 ms
% Copy these values into the last column of allaccessEPSC and/or allaccessIPSC 
% If value is "not found" on Clampfit, change to NaN in Matlab then execute next section

%% Plot access resistance against 10-90% rise time %%

allaccessEPSC(any(isnan(allaccessEPSC),2),:) = []; % Gets rid of rows that have NaN
ERa = allaccessEPSC(:,4);
ERiseTimes = allaccessEPSC(:,5);
% Get coefficients of a line fit through the data.
coefficients = polyfit(ERa, ERiseTimes, 1);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(ERa), max(ERa));
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
h1 = figure;
plot(ERa, ERiseTimes, 'b.', 'MarkerSize', 15); % Plot original data.
hold on;
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
title([run ' - EPSC sweeps']);
xlabel('Access Resistance (MOhm)');
ylabel('10-90% Rise Time (ms)');
savefig(h1, ['' num2str(file) '' ' EPSCs post-gabazine']);
hold off;

allaccessIPSC(any(isnan(allaccessIPSC),2),:) = []; % Gets rid of rows that have NaN
IRa = allaccessIPSC(:,4);
IRiseTimes = allaccessIPSC(:,5);
% Get coefficients of a line fit through the data.
coefficients = polyfit(IRa, IRiseTimes, 1);
% Create a new x axis with exactly 1000 points (or whatever you want).
xFit = linspace(min(IRa), max(IRa));
% Get the estimated yFit value for each of those 1000 new x locations.
yFit = polyval(coefficients , xFit);
% Plot everything.
h2 = figure;
plot(IRa, IRiseTimes, 'b.', 'MarkerSize', 15); % Plot original data.
hold on;
plot(xFit, yFit, 'r-', 'LineWidth', 2); % Plot fitted line.
title([run ' - IPSC sweeps']);
xlabel('Access Resistance (MOhm)');
ylabel('10-90% Rise Time (ms)');
savefig(h2, ['' num2str(file) '' ' IPSCs']);
hold off;
