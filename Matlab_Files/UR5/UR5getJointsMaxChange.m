function [ maxChange ] = UR5getJointsMaxChange( obj )
%UR5GETHELP - Delivers the maximum joint changes for the connected robot
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   29.05.2016
%   Last modified:  29.05.2016
%   Change Log:

receive = UR5sendCommand(obj,'GetJointsMaxChange');
maxChange = UR5str2double(receive,'varCol',6);

end

