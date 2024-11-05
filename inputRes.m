function varargout = inputRes(sweeps,baseline_search,membrane_search,Fs)
% Edited by Kayla Fernando (11/5/24)
% Calculate input resistance (Ri) for all determined range of sweeps 
%   Inputs:
%       sweeps = sweeps to analyze
%       baseline_search = search window of baseline in s, formatted [t1 t2] 
%       membrane_search = search window of test pulse baseline in s, formatted [t1 t2]
%       Fs = sampling rate in Hz
%   Outputs:
%       [out] = the last column of allInput, Ri in megaohms (MOhm)
%       [out,table] = the last column of allInput, Ri in megaohms (MOhm); table of calculations

sizeSweeps = size(sweeps);

    for ii = 1:sizeSweeps(2)
        allbaseline(ii,1) = mean(sweeps((Fs*baseline_search(1)-49):(Fs*baseline_search(2)),ii)); % average baseline current in pA
        allmembrane(ii,1) = mean(sweeps((Fs*membrane_search(1)):(Fs*membrane_search(2)),ii)); % average membrane current in pA
        
        allInput(ii,1) = allbaseline(ii,1) - allmembrane(ii,1); % current in pA
        allInput(ii,2) = allInput(ii,1)./1000000000000; % convert to A
        allInput(ii,3) = -0.005 / allInput(ii,2); % V = IR; solve for R given -0.005 V step; answer in ohms
        allInput(ii,4) = -allInput(ii,3)./1000000; % input resistance in megaohms
    end

if nargout == 1    
    varargout{1} = allInput(:,end);
elseif nargout == 2
    varargout{1} = allInput(:,end);
    varargout{2} = allInput;
end
end
