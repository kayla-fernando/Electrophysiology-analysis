%% REMEMBER PATH CHANGES %%
% Written by Kayla Fernando (9/19/24)

close all
if exist('thresholdsForControl','var') == 1
    clearvars -except thresholdsForControl
else
    clear all
end
clc

% Preprocessing: copy original .abf file, lowpass filter at 2 kHz

% Load original data just for plotting purposes
folder1 = 'folder'; %Naming conventions
run1 = 'run'; %Clampex ABF naming conventions
basepath1 = 'Z:\\';
mousepath1 = [folder1 '\' run1 '.abf'];
[d1,si1,h1] = abfload([basepath1 mousepath1]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% Load filtered data
folder = 'folder'; %Naming conventions
run = 'run'; %Clampex ABF naming conventions
basepath = 'Z:\\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% First and last EPSC in sweep range
sweep_number = [1 20];
num_pulses = 5; % number of PF pulses, determines search window
count = [];
amplitudes_cell = {};
if num_pulses == 3
    search = [0.472 0.672]; % search window in s
elseif num_pulses == 4
    search = [0.482 0.682]; % search window in s
elseif num_pulses == 5
    search = [0.492 0.692]; % search window in s
elseif num_pulses == 6
    search = [0.502 0.702]; % search window in s
elseif num_pulses == 7
    search = [0.512 0.712]; % search window in s
end
control_search = [2.8 3]; %[0.800 1.0]; % search window of last 200 ms of recording
Fs = 50000; % sampling rate in Hz

% Savitzky-Golay filter parameters
sav_golay_order = 2; % 2nd order polynomial (line/first derivative)
sav_golay_bin_width = 151;

% Threshold parameters
thresholdFactor = 2;
blanking_indices = 200;
direction = 'down'; 

%% Event detection (run separately; workspace output will be overwritten)

mkdir(['Z:\\home\kayla\Figures\Strontium event detection\' folder '\' run1 '\' num2str(thresholdFactor) 'SD']);
newFolder = ['Z:\\home\kayla\Figures\Strontium event detection\' folder '\' run1 '\' num2str(thresholdFactor) 'SD'];

forPlotting = cell(1,(sweep_number(2)-sweep_number(1)+1));
for ii = sweep_number(1):sweep_number(2)
    % Original sweep just for plotting purposes
    original_sweep = d1((Fs*search(1)):(Fs*search(2)), ii);
   
    % Sweep to analyze
    single_sweep = d((Fs*search(1)):(Fs*search(2)), ii);

    % Baseline period to use for threshold determination and event detection
    baseline_for_thresh = d((Fs*0.001):(Fs*0.101), ii);
    
    % Filter and plot each sweep
    [filtered_signal_base,event_indices,ax1,ax2,ax3,ax4,ax5,threshold,gof] = plotFilteredSignalStrontium(original_sweep,single_sweep,baseline_for_thresh,run1,run,sav_golay_order,sav_golay_bin_width,thresholdFactor,blanking_indices,direction);
    cd(newFolder); savefig([mat2str(ii) '.fig']); cd('Z:\\home\kayla\MATLAB\Electrophysiology code');
    goodness_of_fit = gof.rsquare
    thresholdsForControl{ii} = threshold;
    if ismember(1,event_indices) == 1
        event_indices = event_indices(2:end); %false positive
    end
    for n = 1:length(event_indices)
        if event_indices(n)+450 < length(filtered_signal_base) & event_indices(n) > 50
            forPlotting{ii}(:,n) = filtered_signal_base(event_indices(n)-50:event_indices(n)+450); % 1 ms pre-dervative and 9 ms post-derivative
        elseif event_indices(n)+450 < length(filtered_signal_base) & event_indices(n) <= 50
            forPlotting{ii}(:,n) = vertcat(NaN(501-length(filtered_signal_base(event_indices(n)-event_indices(n)+1:event_indices(n)+450)),1),...
            filtered_signal_base(event_indices(n)-event_indices(n)+1:event_indices(n)+450));
        else
            forPlotting{ii}(:,n) = vertcat(filtered_signal_base(event_indices(n)-50:length(filtered_signal_base)),...
            NaN(501-length(filtered_signal_base(event_indices(n)-50:length(filtered_signal_base))),1));
        end
    end

    % Find amplitudes for all detected events for all sweeps (instead of using the amplitudes app) 
    amplitudes = eventAmplitudes(ii,filtered_signal_base,event_indices,direction);
    amplitudes_cell{ii} = amplitudes(:,ii);
    amplitudes_cell = amplitudes_cell(~cellfun('isempty',amplitudes_cell));
    [max_amp_events, idx] = max(cellfun('size',amplitudes_cell,1));

end

amplitudes = vertcat(amplitudes_cell{:});
thresholdsForControl = cell2mat(thresholdsForControl)';
forPlotting = horzcat(forPlotting{:});
figure; 
for n = 1:size(forPlotting,2)
    plot(forPlotting(:,n));
    hold on
end
plot(mean(forPlotting,2,'omitnan'),'k','LineWidth',2); title('Aligned detected events');
cd(newFolder); savefig('Aligned detected events.fig'); cd('Z:\\home\kayla\MATLAB\Electrophysiology code');

%% Event detection of last 200 ms of recording (run separately; workspace output will be overwritten)

forPlotting = cell(1,(sweep_number(2)-sweep_number(1)+1));
for ii = sweep_number(1):sweep_number(2)

    % Original sweep just for plotting purposes
    original_sweep = d1((Fs*control_search(1)):(Fs*control_search(2)), ii);

    % Sweep to analyze
    single_sweep = d((Fs*control_search(1)):(Fs*control_search(2)), ii);
    
    % Filter and plot each sweep
    [filtered_signal_base,event_indices,ax1,ax2,ax3,ax4,threshold] = plotFilteredSignalControlStrontium(original_sweep,single_sweep,run1,run,sav_golay_order,sav_golay_bin_width,thresholdsForControl,ii,blanking_indices,direction);
    if ismember(1,event_indices) == 1
        event_indices = event_indices(2:end); %false positive
    end
    for n = 1:length(event_indices)
        if event_indices(n)+450 < length(filtered_signal_base) & event_indices(n) > 50
            forPlotting{ii}(:,n) = filtered_signal_base(event_indices(n)-50:event_indices(n)+450); % 1 ms pre-dervative and 9 ms post-derivative
        elseif event_indices(n)+450 < length(filtered_signal_base) & event_indices(n) <= 50
            forPlotting{ii}(:,n) = vertcat(NaN(501-length(filtered_signal_base(event_indices(n)-event_indices(n)+1:event_indices(n)+450)),1),...
            filtered_signal_base(event_indices(n)-event_indices(n)+1:event_indices(n)+450));
        else
            forPlotting{ii}(:,n) = vertcat(filtered_signal_base(event_indices(n)-50:length(filtered_signal_base)),...
            NaN(501-length(filtered_signal_base(event_indices(n)-50:length(filtered_signal_base))),1));
        end
    end

    % Find amplitudes for all detected events for all sweeps (instead of using the amplitudes app) 
    if ~isempty(amplitudes_cell) == 1
        amplitudes = eventAmplitudes(ii,filtered_signal_base,event_indices,direction);
        amplitudes_cell{ii} = amplitudes(:,ii);
        amplitudes_cell = amplitudes_cell(~cellfun('isempty',amplitudes_cell));
        [max_amp_events, idx] = max(cellfun('size',amplitudes_cell,1));
    else
        continue
    end

end

amplitudes = vertcat(amplitudes_cell{:});
forPlotting = horzcat(forPlotting{:});
figure; 
for n = 1:size(forPlotting,2)
    plot(forPlotting(:,n));
    hold on
end
plot(mean(forPlotting,2,'omitnan'),'k','LineWidth',2); title('Aligned detected events');

%% Make a histogram showing distribution of event amplitudes

forAmpHist = [];
figure;
h = histogram(amplitudes, 'NumBins', 50, 'FaceColor', 'k', 'EdgeColor', 'k'); 
title(['Amplitude histogram']); 
xlabel('Amplitude (pA)'); 
ylabel('Count');

% 220427: adjust renderer parameters to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps
