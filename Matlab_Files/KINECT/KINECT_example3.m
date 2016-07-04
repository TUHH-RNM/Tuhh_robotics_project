%% Data for all
clf
load('KINECT\@KinectImaq\IRKinectParams999999999999.mat')
refPoints = KINECT_importTrackingIni('KINECT/head.ini','round');



for i=1:4
    %% Load data
    if i == 1
        load('KINECT\Snapshots\Snapshot1.mat');
        title1 = 'Snapshot 1';
    elseif i==2
        load('KINECT\Snapshots\Snapshot2.mat');
        title1 = 'Snapshot 2';
    elseif i==3
        load('KINECT\Snapshots\Snapshot4.mat');
        title1 = 'Snapshot 4';
    elseif i==4
        load('KINECT\Snapshots\Snapshot5.mat');
        title1 = 'Snapshot 5';
    end
    
    %% calculate 
    pointsPixel    = KINECT_trackFiducialPixel(imgIR,imgD);
    pointsmm       = KINECT_trackFiducialmm( imgIR,imgD,cp ,'round');
    pointsmm       = KINECT_identifyFiducials(refPoints,pointsmm);
    [coord, base]  = ALGcreateCoordinates(pointsmm);
    
    T           = KINECT_getPosition(pointsmm,refPoints);
    tmp         = T*[refPoints [1;1;1;1]]';
    transPoint  = tmp(1:3,:)';
    
    %% Plot 1
    subplot(2,4,i);
    imshow(imgIR)
    hold on
    title(title1);
    plot(pointsPixel(1,1),pointsPixel(1,2),'r*')
    plot(pointsPixel(2,1),pointsPixel(2,2),'g*')
    plot(pointsPixel(3,1),pointsPixel(3,2),'b*')
    plot(pointsPixel(4,1),pointsPixel(4,2),'m*')
    hold off
    
    %% Plot 2
    subplot(2,4,i+4);
    title('Head coord');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on

%     ALGplotPTP(base,base+coord(1,:),'r');
%     ALGplotPTP(base,base+coord(2,:),'g');
%     ALGplotPTP(base,base+coord(3,:),'b');
    
    %% Tracked Points
    ALGplotPoint(pointsmm(1,:),'r*');
    ALGplotPoint(pointsmm(2,:),'g*');
    ALGplotPoint(pointsmm(3,:),'b*');
    ALGplotPoint(pointsmm(4,:),'m*');
    
    ALGplotPoint(transPoint(1,:),'r^');
    ALGplotPoint(transPoint(2,:),'g^');
    ALGplotPoint(transPoint(3,:),'b^');
    ALGplotPoint(transPoint(4,:),'m^');
    
    grid on
    hold off
end

