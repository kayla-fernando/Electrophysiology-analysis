function out = convert2cell(data)
% Edited by Kayla Fernando (5/4/22)
% Converts numerical arrays into cell arrays and uses a logical to retain
% all nonzero values
%   Inputs:
%           data = array to convert into cell
%   Outputs:
%           out = cell array, each element contains values from one experiment

S = size(data);

C = mat2cell(data,S(1),ones(1,S(2)));

for ii = 1:S(2) 
    sortVals = (any(C{ii}));
    sortVals = (any(C{ii},2));
    Ctemp = C{ii};
    finalVals = Ctemp(sortVals);
    C{ii} = finalVals;
end

out = C;

end