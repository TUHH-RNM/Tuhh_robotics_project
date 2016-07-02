function [ T ] = KINECT_createTransform( refPoints,trcPoints )
%KINECT_createTransform - Creates a transformation matrix which rotates the
%   points from trcPoints into the points of refPoints
%
%   BETA STATUS
%   
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   02.07.2016
%   Last modified:  02.07.2016
%   Change Log:

%% Create orthonormal coordinates from points
[refCoord,refBase] = ALGcreateCoordinates(refPoints);
[trcCoord,trcBase] = ALGcreateCoordinates(trcPoints);

%% Calculate translation
trans = trcBase-refBase;

%% Rotate x-trc to x-ref
rotAx   = cross(trcCoord(1,:),refCoord(1,:));
rotAng  = acosd(dot(refCoord(1,:),trcCoord(1,:)));
rotMat  = ALGrotateMatAngleAxis(rotAng, rotAx);

rotCoord = (rotMat*trcCoord')';

rotAx   = rotCoord(1,:);
rotAng  = acosd(dot(refCoord(2,:),rotCoord(2,:)));
rotMat  = ALGrotateMatAngleAxis(rotAng, rotAx);

rotCoord = (rotMat*rotCoord')';

T = [[rotCoord trans'];[0 0 0 1]];

end

