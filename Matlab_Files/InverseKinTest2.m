%% clear all variables except ... 
clearvars -except robObj DenHartParameters;
clc;

%% Preparations
addFolders();

%% Connect to the Robserver
robObj = UR5connectRobot('192.168.56.101','DispOn');

%% Load the required parameters
load('denHart_UR5');

%% Set speed and verbosity
UR5setSpeed(robObj,120);
UR5sendCommand(robObj,'SetVerbosity 4');

%% Move to random pose, let the robot dance
[randAngl, ~] = UR5moveToRandomPose(robObj);

%% Construct a random pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);
newAngles = anglesFromServer;
newAngles(1) = newAngles(1) + 50;
newAngles(2) = newAngles(2) + 0;
newAngles(3) = newAngles(3) + 0;
newAngles(4) = newAngles(4) + 0;
newAngles(5) = newAngles(5) + 0;
newAngles(6) = newAngles(6) + 0;
% newAngles(1) = -350;
poseRandom = eye(4,4);
for i=1:6
    poseRandom = poseRandom * TRSforwardKinDenHart(DenHartParameters(i,:), newAngles(i)/360*2*pi);
end
clear i;
clc;
[ possibleAngles, anglesSum, minAngles ]  = TRSAnglesFromTargetPose( robObj, poseRandom, DenHartParameters);
UR5movePTPJoints(robObj, minAngles);

%% Get the maximum joint changes
maxJointsChange = UR5getJointsMaxChange(robObj);

%% Set the maximum joint changes
maxJointsChange1 = maxJointsChange;
maxJointsChange1(2) = 720;
out = UR5setJointsMaxChange(robObj, maxJointsChange1);

%% Disconnect from server
UR5disconnectRobot(robObj);