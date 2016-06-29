%% Load data
load('KINECT\Snapshots\Snapshot1.mat');
load('KINECT\@KinectImaq\IRKinectParams999999999999.mat')

refPoints   = KINECT_importTrackingIni('KINECT/head.ini');
trcPoints   = KINECT_trackFiducialmm( imgIR,imgD,cp );
trcPoints   = KINECT_identifyFiducials(refPoints,trcPoints);

%% Translation
trans = trcPoints(1,:);

%% Rotation
rotMat = trcPoints-[trans;trans;trans;trans];