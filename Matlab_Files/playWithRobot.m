%% Preparations
addFolders();
% Connect to the Robserver
robObj = UR5connectRobot('192.168.56.101','DispOn');

%% Load the required parameters
load('DenHartParameters');

%% Get the maximum joint changes
maxJointsChange = UR5getJointsMaxChange(robObj);

%% Set the maximum joint changes
maxJointsChange1 = maxJointsChange;
maxJointsChange1(1) = 720;
out = UR5setJointsMaxChange(robObj, maxJointsChange1);

%% Move to random pose, let the robot dance
% set speed
UR5setSpeed(robObj,120);
% move
[randAngl, ~] = UR5moveToRandomPose(robObj);

%% Construct a random pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);

%%
newAngles = anglesFromServer;
newAngles(1) = newAngles(1) + 40;
newAngles(4) = newAngles(4) + 35;
% newAngles = [1 1 1 1 1 1];
poseRandom = eye(4,4);
for i=1:6
    poseRandom = poseRandom * TRSforwardKinDenHart(DenHartParameters(i,:), newAngles(i)/360*2*pi);
end
clear i;

%% Calculate the best solution for the movement to poseRandom
[possibleAngles, rotSum] = TRSGoToPoseAlternatives(robObj,poseRandom,DenHartParameters);
maxRot = max(rotSum);
minRot = min(rotSum);
indexMaxRot = find(maxRot==rotSum);
indexMinRot = find(minRot==rotSum);
maxAngles = possibleAngles(indexMaxRot,:);
minAngles = possibleAngles(indexMinRot,:);

%%
[ newPosAngles, newSum ] = TRScheckForMaxJointsViolation( robObj, possibleAngles, rotSum);

%%
UR5movePTPJoints(robObj, minAngles);

%%
UR5movePTPJoints(robObj,anglesFromServer);

%% Disconnect from server
UR5disconnectRobot(robObj);