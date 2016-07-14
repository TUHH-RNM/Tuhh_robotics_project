function [ possibleAngles ] = TRScheckForMaxJointsViolation( robObj, theoPossAngles )
% TRScheckForMaxJointsViolation - checks beggining from the best solution
% for the movement if this movement can be done, i.d. if all the six
% angles are in the max range
% 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   13.07.2016
%   Last modified:  13.07.2016
%   Change Log:

%% Check if the angles violate the max change settings
% Get the maximum joint changes
maxJointsChange = UR5getJointsMaxChange(robObj);

% Define the maximum angles
thMin = maxJointsChange*(-1/2);
thMax = maxJointsChange*(1/2);

if isempty(theoPossAngles)
    possibleAngles = [];
else
    dimensions = size(theoPossAngles);
    setsOfAngles = dimensions(1,1);
    NumberOfAngles = dimensions(1,2);
    badAngles = [];
    k=1;

    for i=1:setsOfAngles
        for j=1:NumberOfAngles
            if theoPossAngles(i,j) < thMin(j) || theoPossAngles(i,j) > thMax(j)
                badAngles(k) = i;
                k=k+1;
                break;
            end
        end
    end

    if isempty(badAngles)
        possibleAngles = theoPossAngles;        
    elseif setsOfAngles == numel(badAngles);
        possibleAngles = [];        
    else
        possibleAngles = theoPossAngles;
        possibleAngles(badAngles,:) = [];
    end
end

end