function [ out ] = UR5setAccel(obj, accel)
%UR5setAccel(obj, accel) - Sets the accel given in percent of the maximum 
%   value. 
%   Values between 0-150 are possible
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:
%% Error handling
accel = round(accel);
if(accel < 0)
    accel = 0;
end

if(accel > 150)
    accel = 150;
end

%% Send command
command = ['SetURAccel ' num2str(accel)];
out = UR5sendCommand(obj,command);

end

