function [T,poseRPY,r] = UR5ForwardKinematics(theta,format,varargin)
% UR5FORWARDKINEMATICS computes the different forward kinematics representations of the UR5 from the given joint angles theta
%
%    Info: theta must be an 6 element vector given in rad! T is the HMT, poseRPY is the
%    position stacked with the RPY-angles and v is the rotation vector
%    where the length is equal to the rotation matrix
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-22
%    Change Log:

if numel(theta) ~= 6
    error('\nInput vector must contain 6 elements\n')
end

if strcmp(format,'deg')
    theta = theta*pi/180;
elseif ~strcmp(format,'rad')
    error('\nUnknown Format\n')
end

if nargin > 2
    from = varargin{1};
    to = varargin{2};
else
    from = 6;
    to = 0;
end

% Load DH-parameters
[a,alphaDH,d] = DenavitHartenbergUR5();

T_Set = RefFrameToBaseHMTfromDHparam(a,alphaDH,d,theta);
T = HMTbetweenFrames(T_Set,from,to);
poseRPY = PoseRPYfromHTM(T);
r = RotationVectorFromRM(T(1:3,1:3));

% End of function
end