function [ randomAngles, out ] = UR5moveToRandomPose( obj )
% UR5moveToRandomPose - Moves the robot to a random position 
% that is in the range of the possible joint change
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   16.06.2016
%   Last modified:  16.06.2016
%   Change Log:

% Get the maximum joint changes
maxJointsChange = UR5getJointsMaxChange(obj);

% Set the angles to random values in the possible range 
th1 = maxJointsChange(1)*(rand() - 1/2);
th2 = maxJointsChange(2)*(rand() - 1/2);
th3 = maxJointsChange(3)*(rand() - 1/2);
th4 = maxJointsChange(4)*(rand() - 1/2);
th5 = maxJointsChange(5)*(rand() - 1/2);
th6 = maxJointsChange(6)*(rand() - 1/2);
randomAngles = round([th1 th2 th3 th4 th5 th6],2);

out = UR5movePTPJoints(obj,randomAngles);

end

