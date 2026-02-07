close all
clear all
clc

folder = 'folder';
file = 'events';
cutoff = 50;
basepath = 'Z:\\home\kayla\Electrophysiology analysis\Strontium recordings for Clampfit analysis\';
mousepath = [folder '\' file '.abf'];
[d,si,h] = abfload([basepath mousepath]); clc
Fs = 50000; % sampling rate in Hz
d = squeeze(d);

[~, numEvents] = size(d);
if numEvents < cutoff
    error(['Matrix has fewer than ' num2str(cutoff) ' events']);
end
selectedIdx = randperm(numEvents,cutoff);
selectedEvents = d(:,selectedIdx);

figure; plot(selectedEvents); hold on
plot(mean(selectedEvents,2),'k','LineWidth',2); hold off
for k = 1:size(selectedEvents,2)
    selectedAmps(k,1) = min(movmean(selectedEvents(:,k),101));
end
avgSelectedEvent = min(movmean(mean(selectedEvents,2),101)) % event amplitude using average event from this experiment

%% For strontium event analysis, using cdfEventHistCells

close all
clear all
clc

filename = 'Z:\\home\kayla\Electrophysiology analysis\Strontium recordings for Clampfit analysis\Minis Search cleaned up.xlsx'; 
[~, sheets] = xlsfinfo(filename); 

% Labels. 1 = optotrained, 0 = sham optotrained
labels = [1;1;1;1;0;0;0;0;1;1;1;1;1;1;1;1;0;0;0;0;0;0;0;0;1;1;1;1;0;0;0;0;0;0;1;1;1;1;1;1;1;1;1;];

AllEvents = {};
for n = 1:length(sheets)
    data = [];
    sheetname = sheets{n};
    data = readtable(filename, 'Sheet', sheetname);
    AllEvents{n} = data(:,7);
end

sham = {}; opto = {};
for n = 1:length(labels)
    if labels(n) == 0 % sham optotrained
        sham{n} = AllEvents{n};
    elseif labels(n) == 1 % Optotrained
        opto{n} = AllEvents{n};
    end
end
sham = sham(~cellfun('isempty', sham)); sham = cellfun(@(t) table2array(t), sham, 'UniformOutput', false); sham = cellfun(@(x) -1 .* x, sham, 'UniformOutput', false);
opto = opto(~cellfun('isempty', opto)); opto = cellfun(@(t) table2array(t), opto, 'UniformOutput', false); opto = cellfun(@(x) -1 .* x, opto, 'UniformOutput', false);

forAmpHist = [];

% Sham optotrained
[h1,forAmpHist_sham] = cdfEventHistCells(sham,forAmpHist,'amplitude','pA');
set(h1, 'EdgeColor', [0 0.4470 0.7410]); % blue
forAmpHist_sham_WX = reshape(forAmpHist_sham,[],1); 

hold on;

% Optotrained
[h2,forAmpHist_opto] = cdfEventHistCells(opto,forAmpHist,'amplitude','pA');
set(h2, 'EdgeColor', [0.8500 0.3250 0.0980]); % orange
forAmpHist_opto_WX = reshape(forAmpHist_opto,[],1);

ylim([0 1]);
hold off

[p,h,stats] = ranksum(forAmpHist_sham_WX,forAmpHist_opto_WX)

%% For strontium event analysis, using cdfEventHist

close all
clear all
clc

filename = 'Z:\\home\kayla\Electrophysiology analysis\Strontium recordings for Clampfit analysis\Strontium recordings sorted.xlsx'; 
[~, sheets] = xlsfinfo(filename); 

% Labels. 1 = optotrained, 0 = sham optotrained
labels = [0;1];

AllEvents = {};
for n = 1:length(sheets)
    data = [];
    sheetname = sheets{n};
    data = readtable(filename, 'Sheet', sheetname);
    AllEvents{n} = data(:,7);
end

sham = {}; opto = {};
for n = 1:length(labels)
    if labels(n) == 0 % sham optotrained
        sham{n} = AllEvents{n};
    elseif labels(n) == 1 % Optotrained
        opto{n} = AllEvents{n};
    end
end
sham = sham(~cellfun('isempty', sham)); sham = cellfun(@(t) table2array(t), sham, 'UniformOutput', false); 
sham = cellfun(@(x) -1 .* x, sham, 'UniformOutput', false); sham = cell2mat(sham);
opto = opto(~cellfun('isempty', opto)); opto = cellfun(@(t) table2array(t), opto, 'UniformOutput', false); 
opto = cellfun(@(x) -1 .* x, opto, 'UniformOutput', false); opto = cell2mat(opto);

forAmpHist = [];
figure;
[h1,forAmpHist_sham] = cdfEventHist(sham,[1 1],forAmpHist,'amplitude','pA');
set(h1, 'EdgeColor', 'k');
hold on;
[h2,forAmpHist_opto] = cdfEventHist(opto,[1 1],forAmpHist,'amplitude','pA');
set(h2, 'EdgeColor', 'r');

ylim([0 1]);
hold off;

forAmpHist_sham_WX = reshape(forAmpHist_sham,[],1);
forAmpHist_opto_WX = reshape(forAmpHist_opto,[],1);

[p,h,stats] = ranksum(forAmpHist_sham_WX,forAmpHist_opto_WX)

