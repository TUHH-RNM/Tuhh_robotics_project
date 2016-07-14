function [ angleOut ] = TRS360AngleRotation( angleIn )
% TRS360AngleRotation - represents the same angle as +-360 rotation
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   11.07.2016
%   Last modified:  11.07.2016
%   Change Log:  

%% Calculate the 360 degree version to an angle
if angleIn < 0 && angleIn > -360
    angleOut = 360 + angleIn;
elseif angleIn > 0 && angleIn < 360
    angleOut = angleIn - 360;
elseif angleIn == 360
    angleOut = -360;
else
    angleOut = angleIn;
end

end

