close all
clear all
clc

%% Load data %%

% Preprocessing: copy original .abf file, filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

folder = 'KF_211011_analyzed'; %Naming conventions
run = '211011003 - Copy - analyzed - all traces'; %Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
file = 211011003;
basepath = 'C:\Users\kdf25\Documents\Molecular Devices\pCLAMP\Data\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Method 1: plot pre-gabazine EPSC amplitudes over trials %%

% Select pre-gabazine EPSC sweeps
for ii = 1:10 
    sweep = d(:,ii); 
    stim = min(sweep(37850:40000)); % EPSC is a downward current, stim 1 range in samples, compare with Clampex protocol
    EPSC(ii,1) = -stim;
end

trials = 1:1:length(EPSC);

h1 = figure;
plot(trials,EPSC,'Color','black'); 
title([run ' - pre-gabazine EPSC sweeps']);
xlabel('Trial number');
ylabel('EPSC amplitude (pA)');
savefig(h1, ['' num2str(file) '' ' EPSCs pre-gabazine']);

%% Method 2: plot pre-gabazine EPSCs as one continuous sweep %%

sweep = vertcat(d(:,1),d(:,2),d(:,3),d(:,4),d(:,5),d(:,6),d(:,7),d(:,8),d(:,9),d(:,10));
figure;
plot(sweep);

% Length of one sweep is 10s (50 kHz sampling rate)
duration = 500000;
% Search region of stim 1 range in samples, compare with Clampex protocol
search = [37850 40000];

% Select pre-gabazine EPSC sweeps
for ii = 1:10
    n = duration * (ii - 1); % will add this value to each iteration
    EPSC(ii,1) = -(min(sweep(search(1)+n:search(2)+n))); % new array with EPSC amplitude of each search region
    disp(['Sweep ' num2str(ii) ' starts at ' num2str(n) ' - search from sample ' num2str(search(1)+n) ' to sample ' num2str(search(2)+n)]);
    startline = line([search(1)+n search(1)+n], [-1000, 1000]); % line at start of each search region
    set(startline, 'color', 'r');
    endline = line([search(2)+n search(2)+n], [-1000, 1000]) ; % line at end of each search region
    set(endline, 'color', 'r');
    times(ii,1) = find(sweep == -EPSC(ii,1)); % location of calculated EPSC amplitude in samples
    times(ii,2) = times(ii,1)/50000; % location of calculated EPSC amplitude in seconds
end

trials = 1:1:length(EPSC);

h1 = figure;
plot(trials,EPSC,'Color','black'); 
title([run ' - pre-gabazine EPSC sweeps']);
xlabel('Trial number');
ylabel('EPSC amplitude (pA)');
savefig(h1, ['' num2str(file) '' ' EPSCs pre-gabazine']);

%% Make an XYZ plot of access resistance and EPSC amplitude over trials %%

% Calculate access resistance for all pre-gabazine EPSC sweeps %

% Select pre-gabazine EPSC sweeps
allEPSC = d(:,1:10); 

RaEPSC = access(allEPSC);

% XYZ plot of trials vs Ra vs EPSC amplitude
h2 = figure;
color_line3(trials,RaEPSC,EPSC,trials);
axis auto; view(3);
title([run ' - pre-gabazine Ra vs pre-gabazine EPSC amplitude over trials']);
xlabel('Trial number');
ylabel('Access resistance (MOhm)');
zlabel('EPSC amplitude (pA)');
grid on;
savefig(h2, ['' num2str(file) '' ' pre-gabazine Ra vs pre-gabazine EPSC amplitude over trials']);
