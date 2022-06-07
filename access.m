function varargout = access(sweeps)
% Edited by Kayla Fernando (5/4/22)
% Calculate access resistance (Ra) for all determined range of sweeps 
%   Inputs:
%       sweeps = sweeps to analyze
%   Outputs:
%       [out] = the last column of allAccess, Ra in megaohms (MOhm)
%       [out,table] = the last column of allAccess, Ra in megaohms (MOhm); table of calculations

sizeSweeps = size(sweeps);

    for ii = 1:sizeSweeps(2)
        allAccess(ii,1) = min(sweeps(12800:12900,ii)); % current transient in pA
        allAccess(ii,2) = allAccess(ii,1)./1000000000000; % convert to A
        allAccess(ii,3) = -0.005 / allAccess(ii,2); % V = IR; solve for R given -0.005 V step; answer in ohms
        allAccess(ii,4) = allAccess(ii,3)./1000000; % access resistance in megaohms
    end

if nargout == 1    
    varargout{1} = allAccess(:,4);
elseif nargout == 2
    varargout{1} = allAccess(:,4);
    varargout{2} = allAccess;
end
end
