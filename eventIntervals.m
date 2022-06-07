function intervals = eventIntervals(ii, eventTimes, Fs)
% Edited by Kayla Fernando (5/4/22)
% Calculate inter-event intervals of all detected events in all sweeps
%   Inputs:
%       ii = current sweep number
%       eventTimes = the timestamps of all detected events
%       Fs = sampling frequency (Hz)
%   Outputs:
%       intervals = array of all inter-event intervals for all sweeps, rows: number of intervals detected (n), columns: number of sweeps analyzed (ii)

for n = 1:length(eventTimes)
    if n > 1 % don't count the first event index because you can't subtract anything from it
        intervals(((n)-1),ii) = eventTimes(1,(n)) - eventTimes(1,((n)-1));
        intervals(((n)-1),ii) = ((intervals((n)-1,ii))./Fs).*1000; % convert to ms
    end
end
end