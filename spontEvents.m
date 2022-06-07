%% REMEMBER PATH CHANGES %%

%%%% OUTLINE %%%%
% Section 1: Load data 
% Section 2: sEPSCs
%   Filter signal and detect events in all sweeps
%   Calculate amplitudes from all detected events from all sweeps
%   Calculate inter-event intervals of all detected events in all sweeps
%   cdf amplitude histogram
%   cdf inter-event interval histogram
% Section 3: sIPSCs
%   Filter signal and detect events in all sweeps
%   Calculate amplitudes from all detected events from all sweeps
%   Calculate inter-event intervals of all detected events in all sweeps
%   cdf amplitude histogram
%   cdf inter-event interval histogram
% Section 4: sIPSCs - for gabazine control
% Section 5.1: cdf histograms of all conditions
%   Load workspace
%   Create outputArrays & cdf histograms
%   Two-sample Komolgorov-Smirnov test
%   Wilcoxon rank-sum test
% Section 5.2: cdf histograms combined
%   Create outputArrays & cdf histograms
%   Two-sample Komolgorov-Smirnov test
%   Wilcoxon rank-sum test

% Kayla Fernando (5/4/22)
% Contributions by David Herzfeld, Ph.D. (david.herzfeld@duke.edu)

%% Section 1: Load data %%

close all
clear all
clc

% Load data
folder = 'KF_211011'; % Naming conventions
run = '21o11003'; % Clampex ABF naming conventions
basepath = 'Y:\\All_Staff\home\kayla\Electrophysiology\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); % Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

%% Section 2: sEPSCs %%

% first and last EPSC in sweep range
sweep_number = [9 10];
count = [];
amplitudes_cell = {};
intervals_cell = {};

% Butterworth filter parameters
Fs = 50000; % in Hz
order = 2;
Fc = [1 1000];

% Savitzky-Golay filter parameters
sav_golay_order = 2; % 2nd order polynomial (line/first derivative)
sav_golay_bin_width = 151;

% Threshold parameters
thresholdFactor = 2.6;
blanking_indices = 1500;
direction = 'down'; 

for ii = sweep_number(1):sweep_number(2)
    
    % Sweep to analyze
    single_sweep = d(50000:end, ii);
    
    % Filter and plot each sweep
    [filtered_signal_base,event_indices,ax1,ax2,ax3,ax4] = plotFilteredSignal(single_sweep,run,Fs,order,Fc,sav_golay_order,sav_golay_bin_width,thresholdFactor,blanking_indices,direction);

    % Find amplitudes for all detected events for all sweeps (instead of using the amplitudes app) 
    amplitudes = eventAmplitudes(ii,filtered_signal_base,event_indices,direction);
    amplitudes_cell{ii} = amplitudes(:,ii);
    amplitudes_cell = amplitudes_cell(~cellfun('isempty',amplitudes_cell));
    [max_amp_events, idx] = max(cellfun('size',amplitudes_cell,1));

    % Find inter-event intervals (ms) between counted events
    intervals = eventIntervals(ii, event_indices, Fs);
    intervals_cell{ii} = intervals(:,ii);
    intervals_cell = intervals_cell(~cellfun('isempty',intervals_cell));
    [max_int_events, idx] = max(cellfun('size',intervals_cell,1));
    
    % Generate cumulative fraction histogram for amplitudes
    forAmpHist = [];
    figure;
    h1 = cdfEventHistCells(amplitudes_cell,forAmpHist,'amplitude','pA');
    xlim([0 50]); 
    ylim([0 1]);
    set(h1,'EdgeColor','blue');

    % Generate cumulative fraction histogram for inter-event intervals
    forIntHist = [];
    figure;
    h2 = cdfEventHistCells(intervals_cell,forIntHist,'inter-event interval','ms');
    xlim([0 1000]);
    ylim([0 1]);
    set(h2,'EdgeColor','blue');
    
    pause
    
end

% % UNCOMMENT the rest of this section to save the workspace and run the app
% Save the current workspace
% save filtered_signal_base

% Run the app
% Edit amplitudes code to calculate the MIN moving average value
% Remember to delete filtered_signal_norm.mat when you're done!
% run amplitudes 

%% Section 3: sIPSCs %%

% first and last IPSC in sweep range
sweep_number = [38 39];
count = [];
% thresh = [];
amplitudes_cell = {};
intervals_cell = {};

% Butterworth filter parameters
Fs = 50000;
order = 2;
Fc = [1 2000];

% Savitzky-Golay filter parameters
sav_golay_order = 2; % 2nd order polynomial (line/first derivative)
sav_golay_bin_width = 101;

% Threshold parameters
thresholdFactor = 2.5;
blanking_indices = 1500;
direction = 'up'; 

for ii = sweep_number(1):sweep_number(2)
    
    % Sweep to analyze
    single_sweep = d(50000:end, ii);
    
    % Filter and plot each sweep
    [filtered_signal_base,event_indices,ax1,ax2,ax3,ax4] = plotFilteredSignal(single_sweep,run,Fs,order,Fc,sav_golay_order,sav_golay_bin_width,thresholdFactor,blanking_indices,direction);

    % Find amplitudes for all detected events for all sweeps (instead of using the amplitudes app) 
    amplitudes = eventAmplitudes(ii,filtered_signal_base,event_indices,direction);
    amplitudes_cell{ii} = amplitudes(:,ii);
    amplitudes_cell = amplitudes_cell(~cellfun('isempty',amplitudes_cell));
    [max_amp_events, idx] = max(cellfun('size',amplitudes_cell,1));

    % Find inter-event intervals (ms) between counted events
    intervals = eventIntervals(ii, event_indices, Fs);
    intervals_cell{ii} = intervals(:,ii);
    intervals_cell = intervals_cell(~cellfun('isempty',intervals_cell));
    [max_int_events, idx] = max(cellfun('size',intervals_cell,1));

    % Generate cumulative fraction histogram for amplitudes
    forAmpHist = [];
    figure;
    h1 = cdfEventHistCells(amplitudes_cell,forAmpHist,'amplitude','pA');
    xlim([0 500]);
    ylim([0 1]);
    set(h1,'EdgeColor','red');

    % Generate cumulative fraction histogram for inter-event intervals
    forIntHist = [];
    figure;
    h2 = cdfEventHistCells(intervals_cell,forIntHist,'inter-event interval','ms');
    xlim([0 1000]);
    ylim([0 1]);
    set(h2,'EdgeColor','red');
    
    pause
    
end

% meangaba = mean(thresh(17:33)); % select IPSC sweeps, output is the average value to use for gabazine control

% % UNCOMMENT the rest of this section to save the workspace and run the app
% Save the current workspace
% save filtered_signal_base

% Run the app
% Edit amplitudes code to calculate the MAX moving average value
% Remember to delete filtered_signal_norm.mat when you're done!
% run amplitudes

%% Section 4: sIPSCs - for gabazine control %%

% folder = 'KF_210818_analyzed'; %Naming conventions
% run = '21818006 - Copy - analyzed - all traces'; %Clampex ABF naming conventions
% basepath = 'C:\Users\kdf25\Documents\Molecular Devices\pCLAMP\Data\';
% mousepath = [folder '\' run '.abf'];
% [d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information
% 
% close all
% 
% ctrlcount = [];
%     
% % Create a Butterworth filter
% gaba_sweep = d(50000:end, 63); % select gabazine sweep
% sweep_number = 63;
% % We need to know the sampling frequeny (Fs)
% Fs = 50000; 
% % We need to know the order of the filter to use
% % Increasing the order results in a "tighter" cut-off frequency/sigmoidal curve
% order = 2;
% % We also need the cut-off frequency
% Fc = [5, 2000]; % variable to play around with
% % To construct the filter we call `butter` with the order and 
% % the NORMALIZED cut-off frequency. The cut-off frequency is normalized
% % to the Nyquist.
% [b, a] = butter(order, Fc / (Fs / 2), 'bandpass');
% % Filter the signal in the forward and reverse directions (doubles the order). 
% filtered_signal = filtfilt(b, a, gaba_sweep);
%     
% figure;
% ax1 = subplot(3, 1, 1);
% plot(gaba_sweep); title(['Original signal: ' run ' sweep ' num2str(sweep_number)])
% ax2 = subplot(3, 1, 2);
% plot(filtered_signal); title('Butterworth-filtered signal')
%     
% % Create a Savitzky-Golay filter on the first derivative of the filtered
% % signal
% sav_golay_order = 2; % fits a line through the designated bin width (taking the first derivative of this line)
% sav_golay_bin_width = 101; % variable to play around with
% [b, g] = sgolay(sav_golay_order, sav_golay_bin_width);
% dydx = -conv(filtered_signal, g(:,2), 'same');
% 
% ax3 = subplot(3, 1, 3);
% plot(dydx);
%     
% % Use the threshold value from your experimental group for the gabazine
% % control
% threshold = meangaba;
% refline(0, threshold);
% % refline(0, -threshold);
% 
% % Let's write a very simple threshold and blank algorithm, counting the
% % number of events and where they occur.
% event_indices = []; % A list of indices where threshold crossing occur
% blanking_indices = 900; % variable to play around with
% state = 0; % A state variable (are we above threshold?)
% for i = 1:length(dydx)
%     if (state == 0) && (dydx(i) > threshold)
%         state = 1; % We are above threshold!
%         event_indices = [event_indices i]; % event_indices will increase with each event
%         l = line([i i], [-0.3, 0.3]);
%         set(l, 'color', 'r');
%     elseif (state == 1) && (dydx(i) < threshold) && (i - event_indices(end)) > blanking_indices 
%         state = 0;
%     end
% end
% title('Savitzky-Golay-filtered filtered signal')
% 
% linkaxes([ax1, ax2, ax3], 'x');
% 
% ctrlcount(ii,1) = length(event_indices);
%    
% disp(['The number of events detected in ' num2str(run) ' sweep ' num2str(sweep_number) ' using 1st derivative: ', num2str(length(event_indices))]);

%% Section 5.1: cdf histograms of all conditions %%

% Load workspace
load('spontEventsCopy_ms.mat');

filename = {mIPSC_int_KO_M_RT, mIPSC_int_WT_M_RT, mIPSC_int_KO_F_RT, mIPSC_int_WT_F_RT};

% KO M
mIPSC_int_KO_M_RT_cell = convert2cell(filename{1});
[h1,forIntHist_KO_M_I] = cdfEventHistCells(mIPSC_int_KO_M_RT_cell,forIntHist,'inter-event interval','ms');
set(h1, 'EdgeColor', [0 0.4470 0.7410]);
forIntHist_KO_M_WX_I = reshape(forIntHist_KO_M_I,[],1); 

hold on;

% WT M
mIPSC_int_WT_M_RT_cell = convert2cell(filename{2});
[h2,forIntHist_WT_M_I] = cdfEventHistCells(mIPSC_int_WT_M_RT_cell,forIntHist,'inter-event interval','ms');
set(h2, 'EdgeColor', [0.3010 0.7450 0.9330]);
forIntHist_WT_M_WX_I = reshape(forIntHist_WT_M_I,[],1);

% KO F
mIPSC_int_KO_F_RT_cell = convert2cell(filename{3});
[h3,forIntHist_KO_F_I] = cdfEventHistCells(mIPSC_int_KO_F_RT_cell,forIntHist,'inter-event interval','ms');
set(h3, 'EdgeColor', [0.6350 0.0780 0.1840]);
forIntHist_KO_F_WX_I = reshape(forIntHist_KO_F_I,[],1);

% WT F
mIPSC_int_WT_F_RT_cell = convert2cell(filename{4});
[h4,forIntHist_WT_F] = cdfEventHistCells(mIPSC_int_WT_F_RT_cell,forIntHist,'inter-event interval','ms');
set(h4, 'EdgeColor', [0.8500 0.3250 0.0980]);
forIntHist_WT_F_WX_I = reshape(forIntHist_WT_F,[],1);

xlim([0 1000]);
ylim([0 1]);
hold off

% % Two-sample Komolgorov-Smirnov test 
% % In command window:
% [x,p,ks2stat] = kstest2(forAmpHist_KO_M_KS,forAmpHist_WT_M_KS)

% % Wilcoxon rank-sum test
% % In command window:
% [p,h,stats] = ranksum(forAmpHist_KO_M_WX,forAmpHist_WT_M_WX)

%% Section 5.2: cdf histograms combined %%

% sEPSC amplitude combined
mEPSC_amp_KO = horzcat(mEPSC_amp_KO_M_RT_cell,mEPSC_amp_KO_F_RT_cell);
mEPSC_amp_WT = horzcat(mEPSC_amp_WT_M_RT_cell,mEPSC_amp_WT_F_RT_cell);
figure;
[h1,forAmpHist_KO] = cdfEventHistCells(mEPSC_amp_KO,forAmpHist,'amplitude','pA');
set(h1, 'EdgeColor', 'r');
hold on;
[h2,forAmpHist_WT] = cdfEventHistCells(mEPSC_amp_WT,forAmpHist,'amplitude','pA');
set(h2, 'EdgeColor', 'k');
xlim([0 50]);
ylim([0 1]);
hold off;
forAmpHist_KO_WX = reshape(forAmpHist_KO,[],1);
forAmpHist_WT_WX = reshape(forAmpHist_WT,[],1);

% sEPSC inter-event interval combined
mEPSC_int_KO = horzcat(mEPSC_int_KO_M_RT_cell,mEPSC_int_KO_F_RT_cell);
mEPSC_int_WT = horzcat(mEPSC_int_WT_M_RT_cell,mEPSC_int_WT_F_RT_cell);
figure;
[h3,forIntHist_KO] = cdfEventHistCells(mEPSC_int_KO,forIntHist,'inter-event interval','ms');
set(h3, 'EdgeColor', 'r');
hold on;
[h4,forIntHist_WT] = cdfEventHistCells(mEPSC_int_WT,forIntHist,'inter-event interval','ms');
set(h4, 'EdgeColor', 'k');
xlim([0 1000]);
ylim([0 1]);
hold off;
forIntHist_KO_WX = reshape(forIntHist_KO,[],1);
forIntHist_WT_WX = reshape(forIntHist_WT,[],1);

% sIPSC amplitude combined
mIPSC_amp_KO = horzcat(mIPSC_amp_KO_M_RT_cell,mIPSC_amp_KO_F_RT_cell);
mIPSC_amp_WT = horzcat(mIPSC_amp_WT_M_RT_cell,mIPSC_amp_WT_F_RT_cell);
figure;
[h5,forAmpHist_KO_I] = cdfEventHistCells(mIPSC_amp_KO,forAmpHist,'amplitude','pA');
set(h5, 'EdgeColor', 'r');
hold on;
[h6,forAmpHist_WT_I] = cdfEventHistCells(mIPSC_amp_WT,forAmpHist,'amplitude','pA');
set(h6, 'EdgeColor', 'k');
xlim([0 500]);
ylim([0 1]);
hold off;
forAmpHist_KO_WX_I = reshape(forAmpHist_KO_I,[],1);
forAmpHist_WT_WX_I = reshape(forAmpHist_WT_I,[],1);

% sIPSC inter-event interval combined
mIPSC_int_KO = horzcat(mIPSC_int_KO_M_RT_cell,mIPSC_int_KO_F_RT_cell);
mIPSC_int_WT = horzcat(mIPSC_int_WT_M_RT_cell,mIPSC_int_WT_F_RT_cell);
figure;
[h7,forIntHist_KO_I] = cdfEventHistCells(mIPSC_int_KO,forIntHist,'inter-event interval','ms');
set(h7, 'EdgeColor', 'r');
hold on;
[h8,forIntHist_WT_I] = cdfEventHistCells(mIPSC_int_WT,forIntHist,'inter-event interval','ms');
set(h8, 'EdgeColor', 'k');
xlim([0 1000]);
ylim([0 1]);
hold off;
forIntHist_KO_WX_I = reshape(forIntHist_KO_I,[],1);
forIntHist_WT_WX_I = reshape(forIntHist_WT_I,[],1);

% % Two-sample Komolgorov-Smirnov test 
% % In command window:
% [x,p,ks2stat] = kstest2(forAmpHist_KO_KS,forAmpHist_WT_KS)

% % Wilcoxon rank-sum test
% % In command window:
% [p,h,stats] = ranksum(forAmpHist_KO_WX,forAmpHist_WT_WX)