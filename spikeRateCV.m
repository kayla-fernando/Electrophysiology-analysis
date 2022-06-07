%% REMEMBER PATH CHANGES IN EACH SECTION %%

close all
clear all
clc

%% Count events and calculate spike rate %%

% Preprocessing in Clampfit: Zero baseline, Event Detection - Threshold Search
% copy and paste Results to a new Excel sheet for the purposes of this script and to have the rest of that info for the future 

% Load data
basepath = 'Z:\home\kayla\Ephys analysis\';
mousepath = 'KF_211005_KF64_2.xlsx'; % Naming convention
data = xlsread([basepath mousepath]); % Because you're importing data from Excel, some text and values don't translate well to Matlab variable format

count = [];

 %Raw spike counts over 10s recording window
for ii = 1:20
   count(1,ii) = sum(data(:,1) == ii);
end

% Spikes/s
for jj = 1:20
    count(2,jj) = count(1,jj) / 10;
end

% Copy and paste 'count' array for each mouse into "EC Recordings Summary Spike Counts"
% Excel sheet, then run next section

%% Calculate coefficient of variation for each EC recording %%

% This script uses the raw spike count, NOT the calculated spikes/s

close all
clear all
clc

% Load data
basepath = 'Z:\home\kayla\Ephys analysis\';
mousepath = 'EC Recordings Summary Spike Counts.xlsx';
data = xlsread([basepath mousepath]); % Because you're importing data from Excel, some text and values don't translate well to Matlab variable format
sizeData = size(data); % As you add more rows to the Excel sheet, the first element (which tells you number of rows) will increase accordingly
cutData = data(1:sizeData(1),6:25); % This is the array you will end up working with

for ii = 1:sizeData(1)
    S(ii,1) = std(cutData(ii,:));
    M(ii,1) = mean(cutData(ii,:));
    CV = (S./M)*100;
end

allCV = [S M CV];