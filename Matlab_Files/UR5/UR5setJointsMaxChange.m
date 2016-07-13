function [ out ] = UR5setJointsMaxChange( obj, maxJoints )
%UR5GETHELP - Delivers the maximum joint changes for the connected robot
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   13.07.2016
%   Last modified:  13.07.2016
%   Change Log:


command = ['SetJointsMaxChange' ' ' num2str(maxJoints)];
out = UR5sendCommand(obj,command);

end

