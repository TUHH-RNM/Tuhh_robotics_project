%% Hand-Eye-Calibration

% Preparations
% Add the paths of the needed folders
addpath('UR5');
addpath('TRS');

% Load the neccessary data
load 'DenHartParametersBase';

% Connect to the Robserver

robObj = UR5connectRobot('134.28.45.95','DispOn');
trackObj = TrackingLuebeck('134.28.45.17', 5000, 'coil', 'FORMAT_MATRIXROWWISE');

%% Load or define the initial angles
%load 'initialAngles';
initialAngles = UR5getPositionJoints(robObj);

%% Bringing the the into initial pose
%% Set speed
UR5setSpeed(robObj,10);

%% Bring the robot into the initial position
UR5movePTPJoints(robObj,initialAngles);

%% Calculate the initial pose
initialPose = TRSforwardKinDenHart(DenHartParameters,initialAngles);
initialPose(1:3,4) = initialPose(1:3,4)*1000;

%% Calculate the initial configuration
initialConfig = UR5sendCommand(robObj,'GetStatus');

%% Prelocate memory for the angles of the random poses
randomPose  = zeros(4,4,1);
trackedPose = zeros(4,4,1);
randomAngles = zeros(1,6);
randomConfig = cellstr('');
i = 1;
pause('on');
clear ans

%% Calculate new random poses and bring the robot there
for j=1:50
% choose random points: xyz +- 100;
xRand = rand()*200-100;
yRand = rand()*200-100;
zRand = rand()*200-100;

% phix  = rand()*20-10;
% phiy  = rand()*20-10;
% phiz  = rand()*20-10;
P = 20;
randomRot = randomRotations(1,-P,P,-P,P,-P,P);
randomRot = randomRot{1};
% Construct the new random pose
newPose = initialPose;
newPose(1,4) = newPose(1,4) + xRand;
newPose(2,4) = newPose(2,4) + yRand;
newPose(3,4) = newPose(3,4) + zRand;
newPose(1:3,1:3) = randomRot*newPose(1:3,1:3);

row1 = num2str(newPose(1,:));
row2 = num2str(newPose(2,:));
row3 = num2str(newPose(3,:));

% Let the robot go to the new random pose
command = ['MoveMinChangeRowWiseStatus ' row1 row2 row3 initialConfig];
UR5sendCommand(robObj,command);
clear row1 row2 row3 command;

temp2 = '';
% Check if the robot is there
% posAct = UR5getPositionHomRowWise(robObj);
% compPose = newPose(1:3,:,:);
% while compPose ~= posAct
while 1
%     posAct = UR5getPositionHomRowWise(robObj);
    temp1 = UR5sendCommand(robObj,'GetPositionJoints');
    if strcmp(temp1,temp2)
        break;
    end
    temp2 = temp1;
    pause(0.5);
end

% Calculate the angles of the new random pose and save them
[backAnglesSim, config] = UR5backwardCalc(robObj);
randomAngles(j,1:6) = backAnglesSim;
randomConfig(j,1) = cellstr(config);


% Track pose
[T,visibility,timestamp] = trackObj.getTransformMatrix;
if ~visibility
    randomPose(:,:,j) = NaN*ones(4);
    trackedPose(:,:,j) = NaN*ones(4);
else
    randomPose(:,:,j) = [UR5getPositionHomRowWise(robObj);0 0 0 1];
    trackedPose(:,:,j) = T;
end
% i = i + 1;
clear xRand yRand zRand newPose backAnglesSim ans config temp1 temp2;
end

%% Calculating the matrices from the measurements
% MiX = YNi; => Aw = b
i=1;
Ni = inv(N(4,4,i));
Mi = M(4,4,i);

Ai = ...
[Mi(1:3,1:3)*Ni(1,1) Mi(1:3,1:3)*Ni(2,1) Mi(1:3,1:3)*Ni(3,1) zeros(3,3);
 Mi(1:3,1:3)*Ni(1,2) Mi(1:3,1:3)*Ni(2,2) Mi(1:3,1:3)*Ni(3,2) zeros(3,3);
 Mi(1:3,1:3)*Ni(1,3) Mi(1:3,1:3)*Ni(2,3) Mi(1:3,1:3)*Ni(3,3) zeros(3,3);
 Mi(1:3,1:3)*Ni(1,4) Mi(1:3,1:3)*Ni(2,4) Mi(1:3,1:3)*Ni(3,4) zeros(3,3);];
Ai(1:12,13:24) = -eye(12);

bi = [zeros(1,9) -Mi(1:3,4)']';

rowIndex = ((i-1)*12+1:i*12);
A(rowIndex,1:24) = Ai;
b(rowIndex,1) = bi;

i=i+1;

%% 
w = A\b;

%%
k = 1;
X = [w(1:4); w(5:8); w(9:12)];
Y = [w(13:16); w(17:20); w(21:24)];

k=k+1;

%% Disconnect from server
UR5disconnectRobot(robObj);

%% Collection
%UR5sendCommand(robObj,'EnableURAlter');
%UR5sendCommand(robObj,'DisableAlter');
% command = ['MoveRTHomRowWise ' row1 row2 row3];
