%% Preparations
addFolders();

%% Connect to the Robserver
robObj = UR5connectRobot('192.168.56.101','DispOn');

%% Load the required parameters
load('denHart_UR5');

%% Move to random pose, let the robot dance
% set speed
UR5setSpeed(robObj,120);
% move
[randAngl, ~] = UR5moveToRandomPose(robObj);

%% Construct a random pose
anglesFromServer = round(UR5getPositionJoints(robObj),2);
newAngles = anglesFromServer;
% newAngles(1) = newAngles(1) - 100;
% newAngles(2) = newAngles(2) + 1;
% newAngles(3) = newAngles(3) + 100;
% newAngles(4) = newAngles(4) + 100;
% newAngles(5) = newAngles(5) + 1;
% newAngles(6) = newAngles(6) + 1;
% newAngles = [0 0 0 0 1 0];
poseRandom = eye(4,4);
for i=1:6
    poseRandom = poseRandom * TRSforwardKinDenHart(DenHartParameters(i,:), newAngles(i)/360*2*pi);
end
clear i;
movementStatus = TRSGoToPoseMinAngles( robObj, poseRandom, DenHartParameters );

%% Get the server angles
anglesFromServer = round(UR5getPositionJoints(robObj),2);

%% Construct the initial pose
initialAngles = anglesFromServer;
initialPose = eye(4,4);
for i=1:6
    initialPose = initialPose * TRSforwardKinDenHart(DenHartParameters(i,:), initialAngles(i)/360*2*pi);
end
clear i;

% Query the initial configuration
initialConfig = UR5sendCommand(robObj,'GetStatus');

%% Calculate the rotation matrix from the random angles
anglePM = 30;
XYZtransPM = 200;
randomRot = randomRotations(1,-anglePM,anglePM,-anglePM,anglePM,-anglePM,anglePM);
randomRot = randomRot{1};

% Calculate random translations
xRand = XYZtransPM * (2*rand() - 1);
yRand = XYZtransPM * (2*rand() - 1);
zRand = XYZtransPM * (2*rand() - 1);

% Build the overall random transformation matrix
randomTransformation(1:3,1:3) = randomRot;
randomTransformation(1,4) = xRand/1000;
randomTransformation(2,4) = yRand/1000;
randomTransformation(3,4) = zRand/1000;
randomTransformation(4,1:4) = [0 0 0 1];

% Construct the new random pose
newPose = initialPose*randomTransformation;

% Move
clc;
movementStatus = TRSGoToPoseMinAngles( robObj, newPose, DenHartParameters );

%% Let the robot go to the new random pose
row1 = num2str(newPose(1,:));
row2 = num2str(newPose(2,:));
row3 = num2str(newPose(3,:));
command = ['MoveMinChangeRowWiseStatus' ' ' row1 ' ' row2 ' ' row3 ' ' initialConfig];
UR5sendCommand(robObj,command);

% clear the unnecessary stuff
clear anglePM XYZtransPM xRand yRand zRand randomRot row1 row2 row3


%% Calculate the best solution for the movement to poseRandom
[possibleAngles, rotSum] = TRSAnglesFromTargetPose(robObj, newPose, DenHartParameters);

%% Move to randomPose with minimal angle change
movementStatus = TRSGoToPoseMinAngles( robObj, newPose, DenHartParameters );

%% Move the robot with the angles
UR5movePTPJoints(robObj, anglesFromServer);

%% Move the robot with the angles
UR5movePTPJoints(robObj,[360 0 0 0 0 0]);

%% clear all variables except ... 
clearvars -except robObj DenHartParameters;
clc;

%%
k=1;
for i=1:8
    for j=1:6
        if possibleAngles(i,j) < thMin(j) || possibleAngles(i,j) > thMax(j)
            bad(k,1) = i;
            bad(k,2) = j;
            k=k+1;
            break;
        end
    end
end


%% Get the maximum joint changes
maxJointsChange = UR5getJointsMaxChange(robObj);

%% Set the maximum joint changes
maxJointsChange1 = maxJointsChange;
maxJointsChange1(1) = 720;
out = UR5setJointsMaxChange(robObj, maxJointsChange1);

%% Disconnect from server
UR5disconnectRobot(robObj);