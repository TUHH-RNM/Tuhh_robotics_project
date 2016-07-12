function [ anglesOut ] = TRS360AngleRotation( anglesIn )
% TRS360AngleRotation - represents the same angle as +-360 rotation
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   11.07.2016
%   Last modified:  11.07.2016
%   Change Log:  

%%
for i=1:numel(anglesIn)
    if anglesIn(i) < 0
        anglesOut(i) = 360 + anglesIn(i);
    elseif anglesIn(i) > 0
        anglesOut(i) = anglesIn(i) - 360;
    else
         anglesOut(i) = anglesIn(i);
    end
end



end

