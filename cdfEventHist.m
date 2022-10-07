function [h,outputArray] = cdfEventHist(data,range,outputArray,dataType,dataUnits)
% Edited by Kayla Fernando (5/4/22)
% Generates a cumulative distribution function (cdf) histogram for event
% data by randomly selecting which data points to plot based on the 
% least number of events detected in a sweep (such that all sweeps are
% weighed equally)
%   Inputs:
%       data = numeric array of all event data for all sweeps
%       range = range of sweeps (formatted as [n1 n2])
%       outputArray = array of values included in final plot
%       dataType = the kind of event data that is being analyzed, used for labeling figures here
%       dataUnits = the units of the event data, used for labeling figures here
%   Outputs:
%       h = handle for plot of cdf histogram for event data  
%       outputArray = array of values included in final plot and for further use (e.g. stats)

sD = size(data);                                        % dimensions of original array
cutData = data(:,range(1):range(2));                    % make a copy to edit
cutData(find(cutData == 0)) = NaN;                      % change all zeroes to NaN                 
cutData(any(isnan(cutData),2),:) = [];                  % delete rows that contain NaN
cD = size(cutData);                                     % dimensions of this cut array

for c1 = 1:cD(2)                                        % fill one column one row element at a time, then go to the next column
    for r1 = 1:cD(1)                                    % for the least number of events
        idx(r1,c1) = randi([1,sD(1)],1,1);              % make an indexing array, total rows = least number of events, total cols = number of sweeps,
    end                                                 % element values = random integers based on dimensions of original array (choose from all possible events)
end

sweep_number = range(1);
while sweep_number <= range(2)
    for c2 = 1:cD(2)                                                 % fill one column one row element at a time, then go to the next column
        for r2 = 1:cD(1)                                             % for the least number of events
            outputArray(r2,c2) = data(idx(r2,c2),sweep_number);      % make the array for the histogram with idx to get the array element value from the original array 
            if outputArray(r2,c2) == 0                               % in case the array element value is a zero
                outputArray(r2,c2) = data(randi([1,cD(1)],1,1),c2);  % generate another random integer that will definitely result in a nonzero value
            end
        end
    end
    sweep_number = sweep_number + 1;
end

figure;
h = histogram(outputArray,'Normalization','cdf','DisplayStyle','stairs','LineWidth',1.5); 
title(['Cumulative fraction ' dataType ' histogram']); 
xlabel([dataType ' ' '(' dataUnits ')']); 
ylabel('cumulative fraction');

end
