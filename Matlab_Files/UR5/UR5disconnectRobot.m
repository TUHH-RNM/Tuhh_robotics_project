function [ out ] = UR5disconnectRobot( obj )
%UR5disconnectRobot - Closes the session to the server and closes 
%   the connection to the robot
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

out = UR5sendCommand(obj, 'Quit');
fclose(obj);
end

