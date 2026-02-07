%% Sspk AHP

close all
clear all
clc

% Load data
folder = 'folder'; 
run = 'run'; 
basepath = 'Z:\basepath';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information
clc

% Select all induction sweeps
sweep = d(:,1:30);

baseline_search = [0.001 0.100]; % search window in s
event_search = [0.148 0.152]; % 1st simple spike AP
Fs = 50000; % sampling rate in Hz

for ii = 1:size(sweep,2)
    baseline_sweep(:,ii) = mean(sweep((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
    sweep(:,ii) = sweep(:,ii) - baseline_sweep(:,ii);
    y(:,ii) = sweep((Fs*event_search(1)):(Fs*event_search(2)),ii);
    dy(:,ii) = diff(y(:,ii));
    thresh(:,ii) = find(dy(:,ii) > 0.5, 1,'first');
    y_temp = y(:,ii);
    figure; plot(y(:,ii)); hold on; yline(y_temp(thresh(:,ii)));
    y_line(:,ii) = y_temp(thresh(:,ii))*ones(size(y_temp,1),1);
    x(:,ii) = linspace(1,size(y_temp,1),size(y_temp,1));
    x_int{ii} = polyxpoly(x(:,ii),y(:,ii),x(:,ii),y_line(:,ii));
    if numel(x_int{ii}) == 2
        x_int{ii} = [x_int{ii}; size(y,1)];
    end
    x_temp = x(:,ii);
    x_int_temp = x_int{:,ii};
    X1{ii} = x_temp(x_int_temp(2):x_int_temp(3)); X1{ii} = X1{ii}(:);
    y_line_temp = y_line(:,ii);
    Y2{ii} = y_line_temp(x_int_temp(2):x_int_temp(3));
    Y1{ii} = y_temp(x_int_temp(2):x_int_temp(3));
    fill([X1{ii};flip(X1{ii})], [Y1{ii};flip(Y2{ii})], 'c')
    a{ii} = [x_int_temp(2), x_int_temp(3), x_int_temp(3), x_int_temp(2)];
    b{ii} = [0, 0, y_line_temp(1), y_line_temp(1)];
    A_square(ii) = area(polyshape(a{ii},b{ii}));
    A_curve(ii) = sum(y_temp(x_int_temp(2):x_int_temp(3)));
    AHP(ii) = A_square(ii) - A_curve(ii);
end

AHP = AHP';
mV_sample = mean(AHP) % mV*samples
mV_ms = mean(AHP) * (1/Fs) * 1000 % mV*ms

%% Cspk AHP

close all
clear all
clc

% Preprocessing: lowpass filter at 15 kHz, baseline, create summary traces in Clampfit

% Load data
folder = 'folder'; 
run = 'run'; 
basepath = 'Z:\basepath';
mousepath = [folder '\' run '.abf'];
[d,si,h] = abfload([basepath mousepath]); %Sampling at 50 kHz. d: columns number of samples in a single sweep by the number of sweeps in file; s: sampling interval in us; h: file information
clc

% Select summary induction sweep
sweep = d(:,16); 

event_search = [0.600 5]; % Cspk AHP
Fs = 50000; % sampling rate in Hz

% Convert to indices
e1 = round(Fs*event_search(1));
e2 = round(Fs*event_search(2));
figure
subplot(2,1,1)
plot(sweep(e1:e2)); hold on; yline(0); hold off
title('Original signal')

% Find baseline crossings using a smoothed event window
y = smoothdata(sweep(e1:e2),'movmean',300);
cross_idx = find(y(1:end-1).*y(2:end) <= 0);

% 1st crossing always defines AHP start
i1 = cross_idx(1);

% If there is a 2nd crossing, normal case
if numel(cross_idx) >= 2
    i2 = cross_idx(2);
else
    % If there is only one crossing, integrate to end of signal window
    i2 = length(y);
end

subplot(2,1,2)
plot(y); hold on; yline(0)
fill([i1:i2 fliplr(i1:i2)], [y(i1:i2)' zeros(1,i2-i1+1)], 'c', 'FaceAlpha',0.3, 'EdgeColor','none')
hold off
title('Smoothed signal + AHP')

mV_sample = sum(-y(i1:i2))
mV_ms = mV_sample * (1/Fs) * 1000

%% Sspk AHP without polyxpoly

% close all
% clear all
% clc
% 
% % Load data
% folder = 'folder'; 
% run = 'run'; 
% basepath = 'Z:\basepath';
% mousepath = [folder '\' run '.abf'];
% [d,si,h] = abfload([basepath mousepath]);
% 
% % Select sweep
% sweep = d(:,1:30);
% 
% baseline_search = [0.001 0.100]; % s
% event_search    = [0.151 0.163]; % s
% Fs = 50000;                     % Hz
% 
% for ii = 1:size(sweep,2)
% 
%     % Baseline subtraction
%     baseline_sweep(:,ii) = mean( ...
%         sweep((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii));
%     sweep(:,ii) = sweep(:,ii) - baseline_sweep(:,ii);
% 
%     % Event window
%     y(:,ii)  = sweep((Fs*event_search(1)):(Fs*event_search(2)),ii);
%     dy(:,ii) = diff(y(:,ii));
% 
%     % Threshold from slope
%     thresh(:,ii) = find(dy(:,ii) > 0.5, 1, 'first');
%     y_temp = y(:,ii);
%     y_thresh = y_temp(thresh(:,ii));
% 
%     % Plot
%     figure; plot(y_temp); hold on;
%     yline(y_thresh);
% 
%     % ---- INTERSECTION WITHOUT polyxpoly ----
%     y_diff = y_temp - y_thresh;
% 
%     % Find zero crossings
%     cross_idx = find(diff(sign(y_diff)) ~= 0);
% 
%     % Ensure start/end bounds
%     if numel(cross_idx) < 5
%         cross_idx = [cross_idx; size(y,1)];
%     end
% 
%     cross_idx = cross_idx(2:4);
%     idx1 = cross_idx(2);
%     idx2 = cross_idx(3);
% 
%     % X/Y for filling
%     X1 = (idx1:idx2)';
%     Y1 = y_temp(idx1:idx2);
%     Y2 = y_thresh * ones(size(Y1));
% 
%     fill([X1; flipud(X1)], [Y1; flipud(Y2)], 'c')
% 
%     % Square area
%     a = [idx1 idx2 idx2 idx1];
%     b = [0 0 y_thresh y_thresh];
%     A_square(ii) = area(polyshape(a,b));
% 
%     % Curve area
%     A_curve(ii) = sum(y_temp(idx1:idx2));
% 
%     % AHP area
%     AHP(ii) = A_square(ii) - A_curve(ii);
% 
% end
% 
% mV_sample = mean(AHP)
% mV_ms = mean(AHP) * (1/Fs) * 1000



