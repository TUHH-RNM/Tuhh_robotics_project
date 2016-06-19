function T = HTM_from_poseRPY(poseRPY)
% HTM_FROM_POSERPY Computes the corresponding HTM from the given pose vector
%
%    Author: Nasser Attar
%    Created: 2016-06-18
%    Modified: 2016-06-18
%    Change Log:

if numel(poseRPY) ~= 6
    error('\nInput vector must have 6 elements\n')
elseif size(poseRPY,1) < size(poseRPY,2)
    poseRPY = poseRPY';
end
% Get the Roll angle
r = poseRPY(4);
% Get the Pitch angle
p = poseRPY(5);
% Get the Yaw angle
y = poseRPY(6);

Rr = XRotationMatrix(r);
Rp = YRotationMatrix(p);
Ry = ZRotationMatrix(y);

% Compute the Rotation matrix
R = Ry*Rp*Rr;
T = [R,poseRPY(1:3);[0 0 0 1]];

% End of function
end