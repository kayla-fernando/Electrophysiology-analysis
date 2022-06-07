%% REMEMBER PATH CHANGES%%

close all
clear all
clc

%% 

% Load pre-induction data
folder1 = 'KF_210702';
run1 = '21702000'; % Clampex ABF naming conventions
basepath1 = 'Z:\home\kayla\Electrophysiology\';
mousepath1 = [folder1 '\' run1 '.abf'];
[d1,si1,h1] = abfload([basepath1 mousepath1]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% 

% Bin and calculate average baseline EPSC PPR pre-induction (pA)
jj = 1;
bin1 = [1 6];
while jj < 11 % 10 minutes of pre-induction baseline recs, adjust as needed
    for ii = 1:length(d1)
    binpreEPSC(ii,jj) = mean(d1(ii,bin1(1):bin1(2)));
    end
jj = jj + 1;
bin1(1) = bin1(1) + 6;
bin1(2) = bin1(2) + 6;
end

minpreEstim1 = min(binpreEPSC(37850:40000,:)); % EPSC is a downward current, stim 1 range in samples, compare with Clampex protocol
minpreEstim2 = min(binpreEPSC(42850:45000,:)); % Stim 2 range in samples, compare with Clampex protocol

prePPR = minpreEstim2./minpreEstim1;

%% 

% Load post-induction data
folder2 = 'KF_210702';
run2 = '21702002'; % Clampex ABF naming conventions
basepath2 = 'Z:\home\kayla\Electrophysiology\';
mousepath2 = [folder2 '\' run2 '.abf'];
[d2,si2,h2] = abfload([basepath2 mousepath2]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% 

% Bin and calculate average baseline EPSC PPR post-induction (pA)
ll = 1;
bin2 = [1 6];
while ll < 31 % 30 minutes of post-induction baseline recs, adjust as needed 
    for kk = 1:length(d2)
    binpostEPSC(kk,ll) = mean(d2(kk,bin2(1):bin2(2)));
    end
ll = ll + 1;
bin2(1) = bin2(1) + 6;
bin2(2) = bin2(2) + 6;
end

minpostEstim1 = min(binpostEPSC(37850:40000,:)); % EPSC is a downward current, stim 1 range in samples, compare with Clampex protocol
minpostEstim2 = min(binpostEPSC(42850:45000,:)); % Stim 2 range in samples, compare with Clampex protocol

postPPR = minpostEstim2./minpostEstim1;  

%% 

% Plotting PPR
A = prePPR'; % Transpose pre-induction data 
B = postPPR'; % Transpose the post-induction data
allPPR = [A; B]; % Create one concatenated column of pre- and post-induction normalized EPSCs, REMEMBER TO INCLUDE WAIT TIME IN B/W RECORDINGS
