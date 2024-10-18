%% REMEMBER PATH CHANGES %%
% Written by Kayla Fernando (9/19/24)

close all
clear all
clc

% Preprocessing: copy original .abf file, filter at 2 kHz 

% Load data
folder = 'folder'; %Naming conventions
run = 'run'; %Clampex ABF naming conventions
basepath = 'Z:\\';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information

clc

% first and last EPSC in sweep range
sweep_number = [1 10];
count = [];
amplitudes_cell = {};
search = [0.620 0.820]; % search window in s 
Fs = 50000; % sampling rate in Hz

% Savitzky-Golay filter parameters
sav_golay_order = 2; % 2nd order polynomial (line/first derivative)
sav_golay_bin_width = 151;

% Threshold parameters
thresholdFactor = 1;
blanking_indices = 500;
direction = 'down'; 

for ii = sweep_number(1):sweep_number(2)
    
    % Sweep to analyze
    single_sweep = d((Fs*search(1)):(Fs*search(2)), ii);
    
    % Filter and plot each sweep
    [filtered_signal_base,event_indices,ax1,ax2,ax3,ax4,threshold,gof] = plotFilteredSignalStrontium(single_sweep,run,sav_golay_order,sav_golay_bin_width,thresholdFactor,blanking_indices,direction);
    goodness_of_fit = gof.rsquare

    % Find amplitudes for all detected events for all sweeps (instead of using the amplitudes app) 
    amplitudes = eventAmplitudes(ii,filtered_signal_base,event_indices,direction);
    amplitudes_cell{ii} = amplitudes(:,ii);
    amplitudes_cell = amplitudes_cell(~cellfun('isempty',amplitudes_cell));
    [max_amp_events, idx] = max(cellfun('size',amplitudes_cell,1));
    
end

amplitudes = vertcat(amplitudes_cell{:});

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
