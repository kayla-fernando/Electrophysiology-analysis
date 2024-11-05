close all
clear all
clc

% Preprocessing: copy original .abf file, filter at 15 kHz, create summary traces in Clampfit and calculate E/I ratios,
% save Entire File > All Sweeps and Signals 

folder = 'folder'; % Naming conventions
run = 'run'; % Clampex ABF naming conventions, refer to "E-I Ratio Stats ASTN2" Excel sheet for proper name
basepath = 'basepath';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Calculate input resistance for all EPSC sweeps and all IPSC sweeps %%

allEPSC = d(:,1:10); % Select EPSC sweeps
sizeEPSC = size(allEPSC);
allIPSC = d(:,20:40); % Select IPSC sweeps
sizeIPSC = size(allIPSC);

for ii = 1:sizeEPSC(2)
    allbaseEPSC(ii,1) = mean(allEPSC(1:5000,ii)); % average baseline current in pA
    allmembEPSC(ii,1) = mean(allEPSC(17750:22750,ii)); % average membrane current in pA
    
    allinputEPSC(ii,1) = allbaseEPSC(ii,1) - allmembEPSC(ii,1); % current in pA
    allinputEPSC(ii,2) = allinputEPSC(ii,1)./1000000000000; % convert to A
    allinputEPSC(ii,3) = -0.005 / allinputEPSC(ii,2); % V = IR; solve for R given -0.005 V step; answer in ohms
    allinputEPSC(ii,4) = -allinputEPSC(ii,3)./1000000; % input resistance in megaohms
end

for jj = 1:sizeIPSC(2)
    allbaseIPSC(jj,1) = mean(allIPSC(1:5000,jj)); 
    allmembIPSC(jj,1) = mean(allIPSC(17750:22750,jj)); 
    
    allinputIPSC(jj,1) = allbaseIPSC(jj,1) - allmembIPSC(jj,1); 
    allinputIPSC(jj,2) = allinputIPSC(jj,1)./1000000000000;
    allinputIPSC(jj,3) = -0.005 / allinputIPSC(jj,2);
    allinputIPSC(jj,4) = -allinputIPSC(jj,3)./1000000;
end

%% Calculate input resistance for only summary EPSC and summary IPSC sweeps %%

avgEPSC = d(:,41); % Select EPSC summary sweep
avgIPSC = d(:,42); % Select IPSC summary sweep

avgbaseEPSC = mean(avgEPSC(1:5000));
avgmembEPSC = mean(avgEPSC(17750:22750));

avginputEPSC(1,1) = avgbaseEPSC - avgmembEPSC;
avginputEPSC(1,2) = avginputEPSC(1,1)./1000000000000; 
avginputEPSC(1,3) = -0.005 / avginputEPSC(1,2); 
avginputEPSC(1,4) = avginputEPSC(1,3)./1000000;

avgbaseIPSC = mean(avgIPSC(1:5000));
avgmembIPSC = mean(avgIPSC(17750:22750));

avginputIPSC(1,1) = avgbaseIPSC - avgmembIPSC;
avginputIPSC(1,2) = avginputIPSC(1,1)./1000000000000;
avginputIPSC(1,3) = -0.005 / avginputIPSC(1,2);
avginputIPSC(1,4) = avginputIPSC(1,3)./1000000;
