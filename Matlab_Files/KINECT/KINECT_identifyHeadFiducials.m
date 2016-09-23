function headMarkerPoints = KINECT_identifyHeadFiducials(trackedPoints)
% KINECT_IDENTIFYHEADFIDUCIALS takes a set of positions and estimate the head marker frame from that.
%   
%   Author:         Nasser Attar
%   Date created:   14.07.2016
%   Last modified:  14.07.2016
%   Change Log:    

nTrackedPoints = size(trackedPoints,1);
for i = 1:trackedPoints
    point0 = trackedPoints(i,:);
    point0OriginVectors = trackedPoints - ones(nTrackedPoints,1)*point0;
    distancesToPoint0 = sqrt(sum(point0OriginVectors.^2,2));
    nearEnoughMask = distancesToPoint
end

% End of function
end