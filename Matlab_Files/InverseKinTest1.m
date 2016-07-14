%% clear all variables except ... 
clearvars -except robObj DenHartParameters;
clc;

%% Preparations
addFolders();

%%
pause('on');

%% Connect to the Robserver
robObj = UR5connectRobot('192.168.56.101','DispOn');

%% Load the required parameters
load('denHart_UR5');

%% Set speed and verbosity
UR5setSpeed(robObj,120);
UR5sendCommand(robObj,'SetVerbosity 4');

%% Move to random pose, let the robot dance
[randAngl, ~] = UR5moveToRandomPose(robObj);

%% Construct the initial pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);
initialAngles = anglesFromServer;
initialPose = eye(4,4);
for i=1:6
    initialPose = initialPose * TRSforwardKinDenHart(DenHartParameters(i,:), initialAngles(i)/360*2*pi);
end
clear i;

%% Calculate the rotation matrix from the random angles
anglesBegin = round(UR5getPositionJoints(robObj),2);
anglePM = 45;
XYZtransPM = 250;

% Construct random HMT
randomTransformation = RandomHMT(anglePM, XYZtransPM);

% Construct the new random pose
newPose = initialPose*randomTransformation;

% Move
clc;
[ resultAngles, anglesSum, minAngles ]  = TRSAnglesFromTargetPose( robObj, newPose, DenHartParameters);
UR5movePTPJoints(robObj, minAngles);
clear anglePM XYZtransPM randomRot xRand yRand zRand randomTransformation ans;

pause(1);
AnglesInBetween = round(UR5getPositionJoints(robObj),2);

%% Disconnect from server
UR5disconnectRobot(robObj);