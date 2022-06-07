function [h,outputArray] = cdfEventHistCells(data,outputArray,dataType,dataUnits)
% Edited by Kayla Fernando (5/4/22)
% Generates a cumulative distribution function (cdf) histogram for event
% data by randomly selecting which data points to plot based on the 
% least number of events detected in a sweep (such that all sweeps are
% weighed equally)
%   Inputs:
%       data = cell array of all event data for all sweeps
%       outputArray = array of values included in final plot
%       dataType = the kind of event data that is being analyzed, used for labeling figures here
%       dataUnits = the units of the event data, used for labeling figures here
%   Outputs:
%       h = handle for plot of cdf histogram for event data
%       outputArray = array of values included in final plot and for further use (e.g. stats)

cD(1) = min(cellfun('size',data,1));
cD(2) = length(data);

k1 = 1;
c1 = 1;
while k1 <= cD(2) & c1 <= cD(2)                                   % fill one column one row element at a time, then go to the next column
    for r1 = 1:cD(1)                                              % for the least number of events        
        idx(r1,c1) = randi([1,length(data{k1})],1,1);             % make an indexing array, total rows = least number of events, total cols = number of sweeps,
    end
    k1 = k1 + 1;
    c1 = c1 + 1;
end                                                               % element values = random integers based on dimensions of original array (choose from all possible events)

k2 = 1;
c2 = 1;
while k2 <= cD(2) & c2 <= cD(2)                                   % fill one column one row element at a time, then go to the next column
    for r2 = 1:cD(1)                                              % for the least number of events
        datatemp = data{k2};
        outputArray(r2,c2) = datatemp(idx(r2,c2));                % make the array for the histogram with idx to get the array element value from the original array 
    end
    k2 = k2 + 1;
    c2 = c2 + 1;
end

assignin('base','outputArray',outputArray);

h = histogram(outputArray,'Normalization','cdf','DisplayStyle','stairs','BinWidth',1,'LineWidth',1.5); 
title(['Cumulative fraction ' dataType ' histogram']); 
xlabel([dataType ' ' '(' dataUnits ')']); 
ylabel('cumulative fraction');

% 220420: adjust renderer parameters for cdfs to export as .eps vector files
set(gcf,'renderer','Painters')
print -depsc -tiff -r300 -painters test.eps

end