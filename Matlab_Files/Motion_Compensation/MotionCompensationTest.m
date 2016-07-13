%% Script for Motion Compensation

%% Connect with the robot
% Before executing these commands, invoke the (non-blocking) rob6server
robObj = UR5connectRobot('134.28.45.95');
UR5sendCommand(robObj,'SetSpeed 120');
UR5sendCommand(robObj,'SetVerbosity 4');

%% Connect with the Tracking Server for Hand-Eye Calibration
trackObjCoil = GetTrackingObject('coil');

%% Hand-Eye Calibration
load('DenHartParameters');
[ randomPose, trackedPose] = HandEyeCalibrationCollectingData(robObj, trackObjCoil, DenHartParameters, 40, 70,'maxRotAngle',30,'maxXYZtrans',200);
[X, Y] = HandEyeCalibrationCalculatingXY(randomPose, trackedPose);

fprintf('Number of valid measurements %d\n',nnz(~isnan(randomPose(1,1,:))));

%% Compute the maximum error 
errorMax = 0;
for i=1:70
    E = (randomPose(:,:,i)*X/trackedPose(:,:,i))/Y;
    if errorMax < sqrt(E(1,4)^2 + E(2,4)^2 + E(3,4)^2) && ~isnan(E(1,1));
        errorMax = sqrt(E(1,4)^2 + E(2,4)^2 + E(3,4)^2);
    end
end
%% Connect with the Tracking Server for head tracking
trackObjHead = GetTrackingObject('head');

%% (Optionally) Initialize Kinect for head tracking
kin = KINECT_initialize('head',999999999999);

%% Specify the desired transformation from Head to Coil
% Important !!! Bring the coil in the desired position relative to the coil
[T_TS_H,visibility,~] = trackObjHead.getTransformMatrix();
% [T_TS_H,visibility] = KINECT_getMarkerFrameHMT(kin);
if ~visibility
    warning('Head is not visible\n')
end
T_B_H = Y*T_TS_H;

T_B_E = UR5getPositionHomRowWise(robObj);
T_B_E(1:3,4) = T_B_E(1:3,4)*1000;
T_B_C = T_B_E*X;
T_C_H_des = invertHTM(T_B_C)*T_B_H;

%% Do the actual Motion Compensation
% command = 'EnableAlter';
% % Enable real time mode
% UR5sendCommand(robObj,command); 
h = figure('KeyPressFcn','keep=0');
keep = true;
while keep
    MotionCompensationPrimitive(robObj,trackObjHead,X,Y,T_C_H_des,'atrcsys')
    pause(0.01)
end