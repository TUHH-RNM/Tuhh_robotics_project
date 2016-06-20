function [T,poseRPY] = UR5ForwardKinematics(theta,varargin)
% UR5FORWARDKINEMATICS computes the the HTM of the UR5 from the given joint angles theta
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

if numel(theta) ~= 6
    error('\nInput vector must contain 6 elements\n')
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

% End of function
end