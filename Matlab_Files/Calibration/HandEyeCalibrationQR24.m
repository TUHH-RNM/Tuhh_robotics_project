function [X,Y] = HandEyeCalibrationQR24(robObj,n,varargin)
% HANDEYECALIBRATION returns a HMT denoting the transformation from marker frame to end effector frame
%    The input trackObj must be an valid instance of the
%    TrackingLuebeck-class
%
%    Author: Nasser Attar
%    Created: 2016-06-21
%    Modified: 2016-06-21
%    Change Log:

minNargs = 1;
maxNargs = 2;
narginchk(minNargs,maxNargs)

if numel(varargin) > 0
    trackObj = varargin{1};
else
    trackObj = TrackingLuebeck('134.28.45.17',5000,'MarkerGeometry',FORMAT_MATRIXROWWISE);
end

% Move the Robot into good position, where it can freely operate. This
% position is calles 'home position'
if ~UR5moveToHomePosition(robObj)
    error('\nRobot could not be moved to home position\n')
end

% Use the actual position of the robot as starting point 
robHMT = UR5getPositionHomRowWise(robObj);
robPos = robHMT(1:3,4);

startRadius = 0.5*sqrt(sum(robPos.^2));
radiusRange = [-0.6*startRadius,-0.2*StartRadius];
elevationRange = [-30,30]*pi/180;
azimuthRange = [-180,180]*pi/180;

% Compute now random positions which are in the specified section around
% the starting point
positions = randomSpherePoints(n,robPos(1),robPos(2),robPos(3),radiusRange,azimuthRange,elevationRange);

% Compute random rotations 
R = randomRotations(n,-180,180,-45,45,-180,180);

% End of function
end