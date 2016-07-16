%% Script for Motion Compensation

% Cell array with options for the motion compensation function
mcOptions = [];

% Specify whether Kinect or Atrcsys should be used for tracking
useKinect = 'Shall the Kinect be used?\nIf yes, enter a number above 0\n';
useKinect = input(useKinect);
if useKinect > 0
    useKinect = true;
    mcOptions = [mcOptions,{'kinect'}];
else
    useKinect = false;
end
%% Connect with the robot
% Before executing these commands, invoke the (non-blocking) rob6server
robObj = UR5connectRobot('134.28.45.95','Port',5003);
UR5sendCommand(robObj,'SetVerbosity 4');

%% Connect with the Tracking Server for Hand-Eye Calibration
trackObjCoil = GetTrackingObject('coil');

%% Hand-Eye Calibration
% Load the necessary Denavit-Hartenberg parameters from the mat-file
load('DenHartParametersUR3');
[randomPose,trackedPose] = HandEyeCalibrationCollectingData(robObj, trackObjCoil, DenHartParameters, 40, 70,'maxRotAngle',30,'maxXYZtrans',100);
[X,Y] = HandEyeCalibrationCalculatingXY(randomPose, trackedPose);

fprintf('Number of valid measurements %d\n',nnz(~isnan(randomPose(1,1,:))));

%% Compute the maximum error 
errorMax = 0;
for i=1:70
    E = (randomPose(:,:,i)*X/trackedPose(:,:,i))/Y;
    if errorMax < sqrt(E(1,4)^2 + E(2,4)^2 + E(3,4)^2) && ~isnan(E(1,1));
        errorMax = sqrt(E(1,4)^2 + E(2,4)^2 + E(3,4)^2);
    end
end
fprintf('Maximum calibration error is %d\n',errorMax);

%% Connect with the Tracking Server for head tracking
trackObjHead = GetTrackingObject('head');

%% (Optionally) Initialize Kinect for head tracking
load('KINECT\kinObj.mat');
GUI_config_KINECT;
kinObjHead = kin;

%% Compute HMT from Kinect to Base
% The Y from the Hand-Eye Calibration is the HTM from the Tracking system
% to base. If the Kinect shall be used we need the HMT T_TS_K
if useKinect
    [T_TS_H_1,visibility] = trackObjHead.getTransformMatrix();
    T_K_H_1 = KINECT_getMarkerFrameHTM(kinObjHead);
    if ~visibility
        warning('Head is not visible\n')
    end
    T_TS_K = T_TS_H_1*invertHTM(T_K_H_1);
    Y_K = Y*T_TS_K;
end

%% Specify the desired transformation from Head to Coil
% Important !!! Bring the coil in the desired position relative to the coil
if useKinect
    [T_TS_H,visibility] = KINECT_getMarkerFrameHMT(kinObjHead);
else
    [T_TS_H,visibility,~] = trackObjHead.getTransformMatrix();
end
if ~visibility
    warning('Head is not visible\n')
end
T_B_H = Y*T_TS_H;

T_B_E = UR5getPositionHomRowWise(robObj);
T_B_E(1:3,4) = T_B_E(1:3,4)*1000;
T_B_C = T_B_E*X;
T_C_H_des = invertHTM(T_B_C)*T_B_H;

% % Demanded by the project task
% T_H_C_des = [0.868967 0.203085 -0.451281 48.631371;
%              0.331437 -0.916017 0.225975 -85.534794;
%              -0.367487 -0.345935 -0.863298 126.256582;
%              0 0 0 1];
% T_C_H_des = invertHTM(T_H_C_des);         

%% (Optional) Activate Real time. Don't forget to announce it to the MC-function!!
UR5sendCommand(robObj,'EnableAlter');
mcOptions = [mcOptions,{'rtMode'}];

%% Make a figure handles
UR5sendCommand(robObj,'SetSpeed 20');
h = figure('KeyPressFcn','keep=0');
keep = true;

%% Do the actual Motion Compensation
while keep
    if useKinect
        MotionCompensationPrimitive(robObj,kinObjHead,X,Y_K,T_C_H_des,DenHartParameters,mcOptions{:});
    else
        MotionCompensationPrimitive(robObj,trackObjHead,X,Y,T_C_H_des,DenHartParameters,mcOptions{:});
    end
    pause(0.01)
end