%% Script for Motion Compensation

%% Connect with the robot
robObj = UR5connectRobot('134.28.45.95');

%% Connect with the Tracking Server for Hand-Eye Calibration
trackObj = GetTrackingObject('coil');

%% Hand-Eye Calibration

load('DenHartParameters');
[ randomPose, trackedPose] = HandEyeCalibrationCollectingData(robObj, trackObj, DenHartParameters, 20, 50,'maxRotAngle',30,'maxXYZtrans',200);
[X, Y] = HandEyeCalibrationCalculatingXY(randomPose, trackedPose);

%% Connect with the Tracking Server for motion compensation
trackObj = GetTrackingObject('head');

%% Specify the desired transformation from Head to Coil
% Important !!! Bring the coil in the desired position relative to the coil
T_B_E = UR5getPositionHomRowWise(robObj);
T_B_C = T_B_E*X;

T_TS_H = trackObj.getTransformMatrix();
T_B_H = Y*T_TS_H;

T_C_H_des = invertHTM(T_B_C)*T_B_H;
%% Dot the actual Motion Compensation
h = figure('KeyPressFcn','keep=0');
keep = true;
while keep
    MotionCompensationPrimitive(robObj,trackObj,X,Y,T_C_H_des,'tr')
    pause(0.1)
end