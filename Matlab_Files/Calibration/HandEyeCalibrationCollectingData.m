function [ randomPose, trackedPose] = HandEyeCalibrationCollectingData(robObj, trackObj, DenHartParameters, robSpeed, measurements, varargin )
% HandEyeCalibrationCollectingData - moves the robot to different poses
% in the area of +-100mm and +- 15 degrees from the initial pose and
% measures the distance between the markers and the tracking device.
% The number of measurements has to be set. The respective poses from
% base to endeffector as well as the tracked poses from the
% tracking device to the markers are stored and put out. 
%   
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   19.06.2016
%   Last modified:  26.06.2016
%   Change Log:

% Enable the pause function to wait for the robot
pause('on');

%% Load or define the initial angles
% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'initialAngles')
        initialAngles = varargin{i+1};
    else
        initialAngles = UR5getPositionJoints(robObj);
    end
end

%% Bringing the robot into the initial pose
% Set speed
UR5setSpeed(robObj,robSpeed);

% Bring the robot into the initial position
UR5movePTPJoints(robObj,initialAngles);

% Wait until the joints don't change anymore (robot arrived)
temp2 = 'a';
while 1
    temp1 = UR5sendCommand(robObj,'GetPositionJoints');
    if strcmp(temp1,temp2)
        break;
    end
    temp2 = temp1;
    pause(0.5);
end

%% Calculate the initial pose
initialPose = TRSforwardKinDenHart(DenHartParameters,initialAngles);
initialPose(1:3,4) = initialPose(1:3,4)*1000;

% Query the initial configuration
initialConfig = UR5sendCommand(robObj,'GetStatus');s

%% Prelocate memory for the random poses
randomPose  = zeros(4,4,1);
trackedPose = zeros(4,4,1);
% randomAngles = zeros(1,6);
% randomConfig = cellstr('');

%% Calculate new random poses and bring the robot there
for j=1:measurements
    
% maximum values for the rotation and translation 
anglePM = 15;           % +- degree
XYZtransPM = 100;       % +- mm

% Calculate the rotation matrix from the random angles
angleXRand = anglePM * (2*rand() - 1);
angleYRand = anglePM * (2*rand() - 1);
angleZRand = anglePM * (2*rand() - 1);
Rx = XRotationMatrix(angleXRand/360*2*pi);
Ry = YRotationMatrix(angleYRand/360*2*pi);
Rz = ZRotationMatrix(angleZRand/360*2*pi);
randomRot = Rx*Ry*Rz;

% Calculate random translations
xRand = XYZtransPM * (2*rand() - 1);
yRand = XYZtransPM * (2*rand() - 1);
zRand = XYZtransPM * (2*rand() - 1);

% Build the overall random transformation matrix
randomTransformation(1:3,1:3) = randomRot;
randomTransformation(1,4) = xRand;
randomTransformation(2,4) = yRand;
randomTransformation(3,4) = zRand;
randomTransformation(4,1:4) = [0 0 0 1];

% Construct the new random pose 
newPose = initialPose*randomTransformation;

% Let the robot go to the new random pose
row1 = num2str(newPose(1,:));
row2 = num2str(newPose(2,:));
row3 = num2str(newPose(3,:));
command = ['MoveMinChangeRowWiseStatus ' row1 row2 row3 initialConfig];
UR5sendCommand(robObj,command);

% Wait until the joints don't change anymore (robot arrived)
temp2 = 'a';
while 1
    temp1 = UR5sendCommand(robObj,'GetPositionJoints');
    if strcmp(temp1,temp2)
        break;
    end
    temp2 = temp1;
    pause(0.5);
end

% % Calculate the angles of the new random pose and save them
% [backAnglesSim, config] = UR5backwardCalc(robObj);
% randomAngles(j,1:6) = backAnglesSim;
% randomConfig(j,1) = cellstr(config);

% Track pose
[T,visibility,timestamp] = trackObj.getTransformMatrix;
if ~visibility
    randomPose(:,:,j) = NaN*ones(4);
    trackedPose(:,:,j) = NaN*ones(4);
else
    randomPose(:,:,j) = [UR5getPositionHomRowWise(robObj);0 0 0 1];
    trackedPose(:,:,j) = T;
end

end