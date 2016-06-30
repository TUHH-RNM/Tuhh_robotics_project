function [distances,pairs] = ALGdistancesBetweenFiducials(fiducials)
% ALGDISTANCEBETWEENFIDUCIALS returns the distance between every pair of fiducials
%
%   Author: Nasser Attar
%   Date created:   30.06.2016
%   Last modified:  30.06.2016
%   Change Log:

nPairs = nchoosek(numel(fiducials),2);
distances = zeros(nPairs,1);
pairs = zeros(nPairs,2);
% Counter for the pairs
n = 0;
for i = 1:nPairs
    x1 = fiducials(i,1);
    y1 = fiducials(i,2);
    z1 = fiducials(i,3);
    
    for j=(i+1):4
        x2 = fiducials(j,1);
        y2 = fiducials(j,2);
        z2 = fiducials(j,3);
        
        n = n + 1;
        distances(n)     = ALGdistancePTP([x1 y1 z1], [x2 y2 z2]);
        pairs(n,:) = [i j];
    end
end

% End of function
end