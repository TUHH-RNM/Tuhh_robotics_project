%% Preparations
addFolders();
% Connect to the Robserver
robObj = UR5connectRobot('192.168.56.101','DispOn');

%% Set new angles / Let the robot dance
% Load the required parameters
load('DenHartParameters');
% Set speed
UR5setSpeed(robObj,120);
% Move to random pose
[randAngl, ~] = UR5moveToRandomPose(robObj);

%% Construct a random pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);
% newAngles = anglesFromServer;
% newAngles(1) = newAngles(1) - 40;
% newAngles(4) = newAngles(4) + 35;
newAngles = [1 1 1 1 1 1];
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
UR5movePTPJoints(robObj, minAngles);

%%
UR5movePTPJoints(robObj,anglesFromServer);

%% Disconnect from server
UR5disconnectRobot(robObj);