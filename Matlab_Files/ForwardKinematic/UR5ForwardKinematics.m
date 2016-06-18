function [T,poseRPY] = UR5ForwardKinematics(theta,src,dest)
% UR5FORWARDKINEMATICS computes the the HTM of the UR5 from the given joint angles theta
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

if numel(theta) ~= 6
    error('\nInput vector must contain 6 elements\n')
end

% Load DH-parameters
denavit_hartenberg_ur5

T_Set = generate_BaseToRefFrameHMT_from_DHparam(a,alphaDH,d,theta);
T = homogTrans_between_Frames(T_Set,src,dest);
poseRPY = poseRPY_from_HTM(T);

% End of function
end