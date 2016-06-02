function [ out ] = UR5setSpeed(obj, speed)
%UR5SETSPEED - Sets the speed given in percent of the maximum value. 
%   Values between 0-120 are possible
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:
%% Error handling
speed = round(speed);
if(speed < 0)
    speed = 0;
end

if(speed > 120)
    speed = 120;
end

%% Send command
command = ['SetUR5Speed ' num2str(speed)];
out = UR5sendCommand(obj,command);

end

