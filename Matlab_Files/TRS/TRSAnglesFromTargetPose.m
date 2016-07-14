function [ resultAngles, anglesSum, minAngles ] = TRSAnglesFromTargetPose( robObj, pose, DenHartParameters)
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
possibleAnglesGeneral = [];

i=1;
for k=1:2
    for l=1:2
        for m=1:2    
            config = cell2mat([conf1(k) ' ' conf2(l) ' ' conf3(m)]);
            out = TRSinverseKinDenHart(pose, DenHartParameters, config);    
            if isempty(out)
                i=i-1;
            else
                possibleAnglesGeneral(i,:) = out;
            end
            i=i+1;
        end
    end
end
clear i j k l m n conf1 conf2 conf3;

%% Tell the user you couldnt find any angles
if isempty(possibleAnglesGeneral) 
    resultAngles = [];
    anglesSum = [];
    msg = 'Impossible pose';
    error(msg);           
else
    %% Check for max joints violation
    possibleAngles = TRScheckForMaxJointsViolation( robObj, possibleAnglesGeneral );
    
    if isempty(possibleAngles)
        resultAngles = [];
        anglesSum = [];
        msg = 'Impossible pose with these joints constraints!';
        error(msg);        
    else    
        %% Calculate the 360 degree rotated angles to the possible angles
        dimensions = size(possibleAngles);
        setsOfAngles = dimensions(1,1);
        NumberOfAngles = dimensions(1,2);

        for i=1:setsOfAngles
            for j=1:NumberOfAngles    
                possibleAngles360(i,j) = TRS360AngleRotation(possibleAngles(i,j));
            end
        end
        clear i j;

        %% Calculate the minimum change in the joints
        for i=1:setsOfAngles
            for j=1:NumberOfAngles

                if possibleAngles(i,j) < 0 && anglesFromServer(j) > 0
                    diffAngles(i,j) = abs(possibleAngles(i,j)) + abs(anglesFromServer(j));
                elseif possibleAngles(i,j) > 0 && anglesFromServer(j) < 0
                    diffAngles(i,j) = abs(possibleAngles(i,j)) + abs(anglesFromServer(j));
                else
                    diffAngles(i,j) = abs(abs(possibleAngles(i,j)) - abs(anglesFromServer(j))); 
                end

                if possibleAngles360(i,j) < 0 && anglesFromServer(j) > 0
                    diffAngles360(i,j) = abs(possibleAngles360(i,j)) + abs(anglesFromServer(j));
                elseif possibleAngles360(i,j) > 0 && anglesFromServer(j) < 0
                    diffAngles360(i,j) = abs(possibleAngles360(i,j)) + abs(anglesFromServer(j));
                else
                    diffAngles360(i,j) = abs(abs(possibleAngles360(i,j)) - abs(anglesFromServer(j))); 
                end

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
                    resultAngles(i,j) = possibleAngles(i,j);
                end
            end
        end
        clear i j;        
        
        %% Choose the minimal angles from the possible
        indexMin = find(anglesSum==min(anglesSum));
        minAngles = resultAngles(indexMin,:);
        
    end
end



end