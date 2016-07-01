%% Load data
load('KINECT\Snapshots\Snapshot2.mat');
load('KINECT\@KinectImaq\IRKinectParams999999999999.mat')

refPoints   = KINECT_importTrackingIni('KINECT/head.ini');
trcPoints   = KINECT_trackFiducialmm( imgIR,imgD,cp,'round' );
trcPoints   = KINECT_identifyFiducials(refPoints,trcPoints);

T = KINECT_createTransform(refPoints,trcPoints);

%% Debugg
refVec = refPoints(2,:) - refPoints(1,:);
trcVec = trcPoints(2,:) - trcPoints(1,:);

refVec = refVec/ALGlenghtVec(refVec);
trcVec = trcVec/ALGlenghtVec(trcVec);

rotAx  = cross(trcVec,refVec);
anglCos	= dot(refVec,trcVec);
angle 	= acosd(anglCos);
rotation = ALGrotateMatAngleAxis(angle(1), rotAx(1,:));

figure
hold on
plot3(refPoints(1,1),refPoints(1,2),refPoints(1,3),'r*');
plot3(refPoints(2,1),refPoints(2,2),refPoints(2,3),'g*');
plot3(refPoints(3,1),refPoints(3,2),refPoints(3,3),'b*');
plot3(refPoints(4,1),refPoints(4,2),refPoints(4,3),'m*');

ALGplotPTP(refPoints(1,:),refPoints(2,:),'r');
ALGplotPTP(refPoints(2,:),refPoints(3,:),'g');
ALGplotPTP(refPoints(3,:),refPoints(4,:),'b');
ALGplotPTP(refPoints(4,:),refPoints(1,:),'m');


trcTrans = [];
trcTrans(1,:) = (T * [trcPoints(1,:) 1]')';
trcTrans(2,:) = (T * [trcPoints(2,:) 1]')';
trcTrans(3,:) = (T * [trcPoints(3,:) 1]')';
trcTrans(4,:) = (T * [trcPoints(4,:) 1]')';
trcTrans(:,4) = [];

plot3(trcTrans(1,1),trcTrans(1,2),trcTrans(1,3),'r+');
plot3(trcTrans(2,1),trcTrans(2,2),trcTrans(2,3),'g+');
plot3(trcTrans(3,1),trcTrans(3,2),trcTrans(3,3),'b+');
plot3(trcTrans(4,1),trcTrans(4,2),trcTrans(4,3),'m+');

ALGplotPTP(trcTrans(1,:),trcTrans(2,:),'r--');
ALGplotPTP(trcTrans(2,:),trcTrans(3,:),'g--');
ALGplotPTP(trcTrans(3,:),trcTrans(4,:),'b--');
ALGplotPTP(trcTrans(4,:),trcTrans(1,:),'m--');

T(1:3,1:3) = rotation;
% T(:,4) = [0;0;0;1];

trcTrans = [];
trcTrans(1,:) = (T * [trcPoints(1,:) 1]')';
trcTrans(2,:) = (T * [trcPoints(2,:) 1]')';
trcTrans(3,:) = (T * [trcPoints(3,:) 1]')';
trcTrans(4,:) = (T * [trcPoints(4,:) 1]')';
trcTrans(:,4) = [];

plot3(trcTrans(1,1),trcTrans(1,2),trcTrans(1,3),'r+');
plot3(trcTrans(2,1),trcTrans(2,2),trcTrans(2,3),'g+');
plot3(trcTrans(3,1),trcTrans(3,2),trcTrans(3,3),'b+');
plot3(trcTrans(4,1),trcTrans(4,2),trcTrans(4,3),'m+');

ALGplotPTP(trcTrans(1,:),trcTrans(2,:),'r:');
ALGplotPTP(trcTrans(2,:),trcTrans(3,:),'g:');
ALGplotPTP(trcTrans(3,:),trcTrans(4,:),'b:');
ALGplotPTP(trcTrans(4,:),trcTrans(1,:),'m:');


xlabel('x');
ylabel('y');
zlabel('z');
