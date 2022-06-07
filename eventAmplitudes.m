function amplitudes = eventAmplitudes(ii, samples, eventTimes, direction)
% Edited by Kayla Fernando (5/4/22)
% Calculate amplitudes of all detected events of all sweeps 
%   Inputs:
%       ii = current sweep number
%       samples = the signal you want to process
%       eventTimes = the timestamps of all detected events
%       direction = set to 'down' if events are downward-going, set to 'up' if events are upward-going 
%   Outputs:
%       amplitudes = array of all event amplitudes for all sweeps, rows: number of events detected (n), columns: number of sweeps analyzed (ii)

for n = 1:length(eventTimes)
    if eventTimes(n)+1500 < length(samples) % don't calculate the last event amplitude if you can't get the appropriate search window
        % Amplitude determined by calculating the mean of a 101-point moving window over the first 1500 
        % samples of a detected event, then finding the minimum/maximum value of these moving means
        if strcmp(direction, 'down') % sEPSCs 
            amplitudes(n,ii) = -min(movmean(samples(eventTimes(n):eventTimes(n)+1500),101));
        elseif strcmp(direction, 'up') % sIPSCs
            amplitudes(n,ii) = max(movmean(samples(eventTimes(n):eventTimes(n)+1500),101));
        end
    end
end
end