%% clear all variables except ... 
clearvars -except robObj DenHartParameters;
clc;

%% Preparations
addFolders();

%%
pause('on');

%% Connect to the Robserver
% robObj = UR5connectRobot('192.168.56.101','DispOn');
robObj = UR5connectRobot('134.28.45.95','Port',5003,'DispOn');

%% Load the required parameters
load('DenHartParametersUR3');

%% Set speed and verbosity
% UR5setSpeed(robObj,120);
UR5setSpeed(robObj,10);
UR5sendCommand(robObj,'SetVerbosity 4');

%% Move to random pose, let the robot dance
[randAngl, ~] = UR5moveToRandomPose(robObj);

%%
anglesFromServer = round(UR5getPositionJoints(robObj),2);
%%
anglesFromServer = round(UR5getPositionJoints(robObj),2);
newAngles = anglesFromServer;
newAngles(1) = 0;
% newAngles(1) = anglesFromServer(1) + 0;
%newAngles(2) = anglesFromServer(2) - 10;
%newAngles(3) = anglesFromServer(3) + 15;

%%
UR5movePTPJoints(robObj, newAngles);

%% Construct the initial pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);
initialAngles = anglesFromServer;
initialPose = eye(4,4);
for i=1:6
    initialPose = initialPose * TRSforwardKinDenHart(DenHartParameters(i,:), initialAngles(i)/360*2*pi);
end
clear i;

%%
UR5sendCommand(robObj,'EnableAlter');

%% Calculate the rotation matrix from the random angles
anglesBegin = round(UR5getPositionJoints(robObj),2);
anglePM = 10;
XYZtransPM = 50;

% Construct random HMT
randomTransformation = RandomHMT(anglePM, XYZtransPM);

% Construct the new random pose
newPose = initialPose*randomTransformation;

% Move
clc;
[ resultAngles, anglesSum, minAngles ]  = TRSAnglesFromTargetPose( robObj, newPose, DenHartParameters);
% UR5movePTPJoints(robObj, minAngles);
UR5moveRTJoints(robObj, minAngles);
clear anglePM XYZtransPM randomRot xRand yRand zRand randomTransformation ans;

%pause(1);
AnglesInBetween = round(UR5getPositionJoints(robObj),2);

%% Disconnect from server
UR5disconnectRobot(robObj);