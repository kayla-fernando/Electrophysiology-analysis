function varargout = plotFilteredSignalStrontium(original_sweep,single_sweep,run1,run,sav_golay_order,sav_golay_bin_width,thresholdFactor,blanking_indices,direction)
% Written by David Herzfeld, Ph.D. (david.herzfeld@duke.edu)
% Edited by Kayla Fernando (5/4/22)
% 
% INPUTS:
%   d: data uploaded from abfload
%   sweep_number: first and last PSC in sweep range
%   run: date, for finding correct .abf file plot labels
%   Fs: sampling frequency (Hz)
%   order: "tightness" of cutoff frequency/sigmoidal curve
%   Fc: cutoff frequency, 2 values for bandpass filtering
%   sav_golay_order: fits a nth degree polynomial through the designated bin width (taking the first derivative/slope of this line)
%   sav_golay_bin_width: sample window to fit polynomial to
%   thresholdFactor: x times the standard deviation
%   direction: 'down' for sEPSCs, 'up' for sIPSCs
%
% OUTPUTS:
%   varargout: event_indices (timestamps of detected events), ax
%   (subplot handles)

    close all
    
    figure;
    ax1 = subplot(5, 1, 1);
    plot(original_sweep); 
    title(['Original signal: ' run1]); 
    ylabel('Amplitude (pA)');

    ax2 = subplot(5, 1, 2);
    plot(single_sweep); 
    title(['2 kHz lowpass-filtered signal: ' run]); 
    ylabel('Amplitude (pA)');
 
    % Fit an exponential and subtract from the original signal
    x = 1:size(single_sweep,1); x = x';
    [f, gof] = fit(x,single_sweep,'exp1');
    coeffvals = coeffvalues(f);
    filtered_signal = single_sweep-(coeffvals(1)*exp(coeffvals(2)*x));
    ax3 = subplot(5, 1, 3);
    plot(filtered_signal);
    title(['Exponential-subtracted signal: ' run]); 
    ylabel('Amplitude (pA)');
    
    % Baseline the filtered signal using the average of the bottom 10% of values
    if strcmp(direction, 'down') % sEPSCs
        filtered_signal_sort = sort(-filtered_signal); % inverting the signal so that events are positive-going
        baseline = -mean(filtered_signal_sort(1:round(length(filtered_signal_sort)*0.1))); % inversing the sign of the baseline value
        filtered_signal_base = filtered_signal - baseline; % subtract this value to shift the filtered signal down
    elseif strcmp(direction, 'up') % sIPSCs
        filtered_signal_sort = sort(filtered_signal); 
        baseline = mean(filtered_signal_sort(1:round(length(filtered_signal_sort)*0.1))); 
        filtered_signal_base = filtered_signal - baseline; % subtract this value to shift the filtered signal up
    end
        
    ax4 = subplot(5, 1, 4);
    plot(filtered_signal_base); title(['Baselined exponential-subtracted signal; baseline value = ' num2str(baseline)]); ylabel('Amplitude (pA)');
    
    % Create a Savitzky-Golay filter on the first derivative of the filtered signal
%     sav_golay_order;
%     sav_golay_bin_width;
    [b, g] = sgolay(sav_golay_order, sav_golay_bin_width);
    dydx = -conv(filtered_signal_base, g(:,2), 'same');

    ax5 = subplot(5, 1, 5);
    plot(dydx); 
     
    % Take the standard deviation of the filtered signal and ask for x * above the standard deviations as the threshold
    threshold = thresholdFactor * std(dydx); 
    % Let's write a very simple threshold and blank algorithm, counting the number of events and where they occur.
    event_indices = []; % A list of indices where threshold crossing occurs 
    state = 0; % A state variable 
    
    for i = 1:length(dydx)
        if strcmp(direction, 'down') % sEPSCs 
            %refline(0, -threshold);
            if (state == 0) && (dydx(i) < -threshold)
                state = 1; % We are below threshold!
                event_indices = [event_indices i]; % event_indices will increase with each event
                l = line([i i], [-2, 2]);
                set(l, 'color', 'r');
            elseif (state == 1) && (dydx(i) > -threshold) && (i - event_indices(end)) > blanking_indices 
                state = 0;
            end
        elseif strcmp(direction, 'up') % sIPSCs
            %refline(0, threshold);
            if (state == 0) && (dydx(i) > threshold)
                state = 1; % We are above threshold!
                event_indices = [event_indices i]; % event_indices will increase with each event
                l = line([i i], [-2, 2]);
                set(l, 'color', 'r');         
            elseif (state == 1) && (dydx(i) < threshold) && (i - event_indices(end)) > blanking_indices 
                state = 0;
            end
        end
    end
        
    title(['Savitzky-Golay-filtered filtered signal; bin width = ' num2str(sav_golay_bin_width) '; events = ' num2str(length(event_indices))]); 
    ylabel('First derivative')
    xlabel('Samples')
    
    linkaxes([ax1, ax2, ax3, ax4, ax5], 'x');
    
    count = length(event_indices);
    
    disp(['The number of events detected in ' num2str(run) ' using 1st derivative: ', num2str(count)]);
    
if nargout > 0
    varargout{1} = filtered_signal_base;
    varargout{2} = event_indices;
    varargout{3} = ax1;
    varargout{4} = ax2;
    varargout{5} = ax3;
    varargout{6} = ax4;
    varargout{7} = ax5;
    varargout{8} = threshold;
    varargout{9} = gof;
end

disp('Press any key to continue')

% Overlay filtered signal over original signal to assess possible asliasing
% Baseline the original signal using the average of the bottom 50% of values
original_sweep_sort = sort(-original_sweep); % inverting the signal so that events are positive-going
baseline = -mean(original_sweep_sort(1:round(length(original_sweep_sort)*0.50))); % inversing the sign of the baseline value
original_sweep_base = original_sweep - baseline; % subtract this value to shift the filtered signal down
figure; plot(original_sweep_base); hold on; plot(single_sweep); title ('Original (blue) & filtered (orange)');

pause 

end
