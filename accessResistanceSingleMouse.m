%% REMEMBER PATH CHANGES %%

% Edited by Kayla Fernando (11/5/24)

close all
clear all
clc

% Assumes using original recordings from Clampex
folder = 'folder'; % Naming conventions
run = 'run'; % Clampex ABF naming conventions
% file = 21720000;
basepath = 'basepath';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Calculate access resistance for all EPSC sweeps and all IPSC sweeps %%

% Select all EPSC sweeps
allEPSC = d(:,1:10); 
% Select all IPSC sweeps
allIPSC = d(:,11:20); 

baseline_search = [0.001 0.100]; % search window in s
search = [0.250 0.260]; % search window in s 
Fs = 50000; % sampling rate in Hz

% Subtract baseline from all traces
for ii = 1:size(allEPSC,2)
    baselineEPSC(ii) = mean(allEPSC((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
end
for ii = 1:size(allEPSC,2)
    allEPSC(:,ii) = allEPSC(:,ii) - baselineEPSC(ii);
end
for ii = 1:size(allIPSC,2)
    baselineIPSC(ii) = mean(allIPSC((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
end
for ii = 1:size(allIPSC,2)
    allIPSC(:,ii) = allIPSC(:,ii) - baselineIPSC(ii);
end

[RaEPSC,allaccessEPSC] = access(allEPSC,search,Fs);
[RaIPSC,allaccessIPSC] = access(allIPSC,search,Fs);

avgRaEPSC = mean(RaEPSC);
avgRaIPSC = mean(RaIPSC);

%% Plot access resistance against 10-90% rise time

% Assumes using preprocessed recordings in Clampex

% Calculate 10-90% rise time in Clampfit w/ search region from 756.5 to 800 ms
% Copy these values into the last column of allaccessEPSC and/or allaccessIPSC 
% If value is "not found" on Clampfit, change to NaN in Matlab then execute next section

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
