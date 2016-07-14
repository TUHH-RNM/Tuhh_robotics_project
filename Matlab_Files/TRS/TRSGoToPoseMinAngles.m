function [ movementStatus ] = TRSGoToPoseMinAngles( robObj, pose, DenHartParameters)
% TRSGoToPoseMinAngles - calculates all possible angles to move from
% the current pose to the given pose and moves the robot to the pose
% with minimal effort
% 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   13.07.2016
%   Last modified:  13.07.2016
%   Change Log:

%% Calculate all solutions for the given movement
[possibleAngles, rotSum] = TRSAnglesFromTargetPose(robObj, pose, DenHartParameters);

if ~isempty(possibleAngles)
    indexMin = find(rotSum==min(rotSum));
    minAngles = possibleAngles(indexMin,:);
    movementStatus = UR5movePTPJoints(robObj, minAngles);
else
    
end

% %% Calculate the angles that dont violate the maxJoints constrains
% [ PossibleAnglesWithoutViolation, newRotSum ] = TRScheckForMaxJointsViolation( robObj, possibleAngles, rotSum);



end



