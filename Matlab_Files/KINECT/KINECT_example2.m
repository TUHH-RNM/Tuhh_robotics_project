%% Load data
load('KINECT\Snapshots\Snapshot2.mat');
load('KINECT\@KinectImaq\IRKinectParams999999999999.mat')

refPoints   = KINECT_importTrackingIni('KINECT/head.ini');
trcPoints   = KINECT_trackFiducialmm( imgIR,imgD,cp,'round' );
trcPoints   = KINECT_identifyFiducials(refPoints,trcPoints);

T = KINECT_createTransform(refPoints,trcPoints);
[refCoord,refBase] = ALGcreateCoordinates(refPoints);
[trcCoord,trcBase] = ALGcreateCoordinates(trcPoints);


%% Debugg


%% create figure
clf
hold on
grid on
xlabel('x');
ylabel('y');
zlabel('z');

%% Plot tracked points
ALGplotPoint(refPoints(1,:),'r+','LineWidth',4);
ALGplotPoint(refPoints(2,:),'g+','LineWidth',4);
ALGplotPoint(refPoints(3,:),'b+','LineWidth',4);
ALGplotPoint(refPoints(4,:),'m+','LineWidth',4);

rot = T(1:3,1:3);
transPoints = (rot*trcPoints')';

ALGplotPoint(transPoints(1,:),'r^','LineWidth',4);
ALGplotPoint(transPoints(2,:),'g^','LineWidth',4);
ALGplotPoint(transPoints(3,:),'b^','LineWidth',4);
ALGplotPoint(transPoints(4,:),'m^','LineWidth',4);