function out = UR5moveToHomePosition(obj,varargin)
% UR5MOVETOHOMEPOSITION moves the UR5 to a "comfortable" position
%
%    Author: Nasser Attar
%    Created: 2016-06-21
%    Modified: 2016-06-21
%    Change Log:

if UR5setSpeed(obj,120)
    fprintf('Speed was set to 120\n');
end
homeJointPos = [0 -90 0 -90 0 0];
out = UR5movePTPJoints(obj,homeJointPos);

% End of function
end