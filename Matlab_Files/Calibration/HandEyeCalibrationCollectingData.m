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
%   Last modified:  27.06.2016
%   Change Log:     27.06.2016: Outsourced some of the code to external
%                               functions

%% Enable the pause function to wait for the robot
pause('on');

%% Load or define the initial angles
% Varargin
initialAngles = [];
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'initialAngles')
        initialAngles = varargin{i+1};
    end
end

%% Bring the robot into the initial pose
% Set speed
UR5setSpeed(robObj,robSpeed);

%% Bring the robot into the initial position. 
% If the initial position was
% not given as input, then the robot stays in his current position.
if ~isempty(initialAngles)
    UR5movePTPJoints(robObj,initialAngles);
else
    initialAngles = UR5getPositionJoints(robObj);
end

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
initialConfig = UR5sendCommand(robObj,'GetStatus');

%% Check whether the maximum rotation angles and translation 
% distances were given as input
anglePM = [];
XYZtransPM = [];
for k = 1:numel(varargin)
    if strcmp(varargin{k},'maxRotAngle')
        anglePM = varargin{k+1};
    elseif strcmp(varargin{k},'maxXYZtrans')
        XYZtransPM = varargin{k+1};
    end
end

% Set default maximum values for the rotation and translation
if isempty(anglePM)
    anglePM = 15;           % +- degree
end
if isempty(XYZtransPM)
    XYZtransPM = 100;       % +- mm
end

%% Prelocate memory for the random poses
randomPose  = zeros(4,4,1);
trackedPose = zeros(4,4,1);
% randomAngles = zeros(1,6);
% randomConfig = cellstr('');

%% Calculate new random poses and bring the robot there
for j=1:measurements
    
    % Calculate the rotation matrix from the random angles
    randomRot = randomRotations(1,-anglePM,anglePM,-anglePM,anglePM,-anglePM,anglePM);
    randomRot = randomRot{1};
    
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
    
    % Track the pose, if the markers are not visible, fill the matrix
    % with NaN, otherwise save the robot pose and the tracked pose
    [T,visibility,~] = trackObj.getTransformMatrix;
    if ~visibility
        randomPose(:,:,j) = NaN*ones(4);
        trackedPose(:,:,j) = NaN*ones(4);
    else
        randomPose(:,:,j) = [UR5getPositionHomRowWise(robObj);0 0 0 1];
        % UR5getPositionHomRomWise gives out the position ( the first 3
        % elements of the 4th column ) in meters, but in this case we need
        % it in millimeters
        randomPose(1:3,4,:) = randomPose(1:3,4,:)*1000;
        trackedPose(:,:,j) = T;
    end
    
end