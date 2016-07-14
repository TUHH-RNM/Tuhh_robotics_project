function [ resultAngles, anglesSum ] = TRSAnglesFromTargetPose( robObj, pose, DenHartParameters)
% TRSAnglesFromTargetPose - calculates all possible angles to move from
% the current pose to the given pose and outputs these angles as well 
% as the sum of angles for each movement so that the user can choose 
% which joints movement he wants to choose 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   12.07.2016
%   Last modified:  13.07.2016
%   Change Log:

%% Calculate the inverse kinematics
anglesFromServer = round(UR5getPositionJoints(robObj),2);

%% Calculate all possible angles for the pose
conf1 = {'flip','noflip'};
conf2 = {'up','down'};
conf3 = {'lefty','righty'};

i=1;
for k=1:2
    for l=1:2
        for m=1:2    
            status = cell2mat([conf1(k) ' ' conf2(l) ' ' conf3(m)]);
            possibleAngles(i,1:6) = TRSinverseKinDenHart(pose, DenHartParameters, status);                      
            i=i+1;
        end
    end
end
clear i j k l m n conf1 conf2 conf3;

%% Calculate the minimum change in the joints
setsOfAngles = 8;
NumberOfAngles = 6;
 
for i=1:setsOfAngles
    diffAngles(i,1:NumberOfAngles) = abs(abs(possibleAngles(i,1:NumberOfAngles)) - abs(anglesFromServer));
    
    possibleAngles360(i,1:NumberOfAngles) = TRS360AngleRotation(possibleAngles(i,1:NumberOfAngles));
    diffAngles360(i,1:NumberOfAngles) = abs(abs(possibleAngles360(i,1:NumberOfAngles)) - abs(anglesFromServer)); 
    
    for j=1:NumberOfAngles 
        diffAnglesMixed(i,j) = min(diffAngles(i,j), diffAngles360(i,j));        
        
        if diffAngles(i,j) < diffAngles360(i,j)
            ZeroOr360Vector(i,j) = 1;
        elseif diffAngles(i,j) > diffAngles360(i,j)
            ZeroOr360Vector(i,j) = -1;
        else
            ZeroOr360Vector(i,j) = 0;
        end
    end
    anglesSum(i) = sum(diffAnglesMixed(i,:));
    
end
clear i j;

for i=1:setsOfAngles
    for j=1:NumberOfAngles
        if ZeroOr360Vector(i,j) == 1 
            resultAngles(i,j) = possibleAngles(i,j);
        elseif ZeroOr360Vector(i,j) == -1 
             resultAngles(i,j) = possibleAngles360(i,j);
        else
            resultAngles(i,j) = possibleAngles360(i,j);
        end
    end
end
clear i j;

end



