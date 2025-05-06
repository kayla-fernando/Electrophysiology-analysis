% Written by Kayla Fernando 

close all
clear all
clc

% Preprocessing: copy original .abf file, lowpass filter at 15 kHz, baseine all sweeps,
% save Entire File > All Sweeps and Signals 

folder = 'folder';
basepath = 'Z:\\home\kayla\Electrophysiology analysis\PF-PC LTD\';
search_1 = [0.617 0.667]; % search window in s for EPSC1
search_2 = [0.717 0.767]; % search window in s for EPSC2
Fs = 50000; % sampling rate in Hz
ind_dur = 5; % induction duration in minutes

% Load pre-induction data 
run1 = 'run1';
mousepath1 = [folder '\' run1 '.abf'];
[pre,si1,h1] = abfload([basepath mousepath1]); 
pre = squeeze(pre); pre = pre'; %pre = pre(1:50,:); 
clc

% Load post-induction data 
run2 = 'run2'; 
mousepath2 = [folder '\' run2 '.abf'];
[post,si2,h2] = abfload([basepath mousepath2]); 
post = squeeze(post); post = post'; %post = post(1:150,:); 
clc

% Average every 10 sweeps (1-min bins)
meanFilterFunction = @(block_struct) mean(block_struct.data);
averagedPre = blockproc(pre, [10 1*Fs], meanFilterFunction)';
averagedPost = blockproc(post, [10 1*Fs], meanFilterFunction)'; 
% averagedPre = averagedPre(:,N:M) % no need to block process if using summary sweeps N:M 
% averagedPost = averagedPost(:,N:M) % no need to block process if using summary sweeps N:M 

% Pre-induction analysis
figure; preEPSC1 = []; preEPSC2 = [];
for n = 1:size(averagedPre,2) % EPSC amplitudes
    preTrace = (averagedPre(:,n)); %preTrace = preTrace(:)-mean(preTrace(1:(0.100*Fs)));
    plot(preTrace); ylim([-1000 1000]); hold on; %((0.5*Fs):(1*Fs))); hold on;
    preEPSC1(n,1) = -min(movmean(preTrace((Fs*search_1(1)):(Fs*search_1(2))),101)); 
    preEPSC2(n,1) = -min(movmean(preTrace((Fs*search_2(1)):(Fs*search_2(2))),101)); 
end
hold off; title('Pre-induction 1-min average traces');
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
[RaPre,RaPre_table] = access(averagedPre,[0.115 0.120],Fs); % Ra
prePPR = preEPSC2./preEPSC1; % PPR

% Post-induction analysis
figure; postEPSC1 = []; postEPSC2 = [];
for n = 1:size(averagedPost,2) % EPSC amplitudes
    postTrace = (averagedPost(:,n)); %postTrace = postTrace(:)-mean(postTrace(1:(0.100*Fs)));
    plot(postTrace); ylim([-1000 1000]); hold on; %((0.5*Fs):(1*Fs))); hold on;
    postEPSC1(n,1) = -min(movmean(postTrace((Fs*search_1(1)):(Fs*search_1(2))),101)); 
    postEPSC2(n,1) = -min(movmean(postTrace((Fs*search_2(1)):(Fs*search_2(2))),101)); 
end
hold off; title('Post-induction 1-min average traces');
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
[RaPost,RaPost_table] = access(averagedPost,[0.115 0.120],Fs); % Ra
postPPR = postEPSC2./postEPSC1; % PPR

% Normalize EPSC amplitudes pre- and post-induction
normPreEPSC1 = []; 
    for n = 1:size(preEPSC1,1)
        normPreEPSC1(n,1) = (preEPSC1(n)/mean(preEPSC1))*100; end
normPostEPSC1 = []; 
    for n = 1:size(postEPSC1,1)
        normPostEPSC1(n,1) = (postEPSC1(n)/mean(preEPSC1))*100; end
normPreEPSC2 = []; 
    for n = 1:size(preEPSC2,1)
        normPreEPSC2(n,1) = (preEPSC2(n)/mean(preEPSC2))*100; end
normPostEPSC2 = [];
    for n = 1:size(postEPSC2,1)
        normPostEPSC2(n,1) = (postEPSC2(n)/mean(preEPSC2))*100; end

% Plot figures
figure; plot(vertcat(normPreEPSC1, nan(ind_dur,1), normPostEPSC1),'.','MarkerSize',16); title('Norm EPSC1 (%)'); yline([100 100], '--'); ylim([0 200])
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
figure; plot(vertcat(normPreEPSC2, nan(ind_dur,1), normPostEPSC2),'.','MarkerSize',16); title('Norm EPSC2 (%)'); yline([100 100], '--'); ylim([0 200])
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
figure; plot(vertcat(prePPR, nan(ind_dur,1), postPPR),'.','MarkerSize',16); title('PPR'); ylim([0 2])
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
figure; plot(vertcat(RaPre, nan(ind_dur,1), RaPost),'.','MarkerSize',16); title('Ra'); ylim([0 10])     
% 220427: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
RaPercentChange = ((mean(RaPost) - mean(RaPre))/abs(mean(RaPre)))*100    
txt = ['Ra % Change = ' num2str(RaPercentChange)]; text(1,9,txt);
