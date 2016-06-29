% clc
ploting = true;


%% Load data
load('KINECT\Snapshots\Snapshot1.mat');
load('KINECT\@KinectImaq\IRKinectParams999999999999.mat')
headPoint   = KINECT_importTrackingIni('KINECT/head.ini');

%% Run tracking
pointsXY    = KINECT_trackFiducialPixel(imgIR,imgD);
XYZ3D       = KINECT_trackFiducialmm( imgIR,imgD,cp );

if ploting
    %% Plot head points
    clf;
    subplot(2,2,1);
    title('Head points');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on

    for i=1:length(headPoint)
        plot3(headPoint(i,1),headPoint(i,2),headPoint(i,3),'*');
    end

    for i=1:3
        x1 = headPoint(i,1);
        y1 = headPoint(i,2);
        z1 = headPoint(i,3);

        for j=(i+1):4
            x2 = headPoint(j,1);
            y2 = headPoint(j,2);
            z2 = headPoint(j,3);
            plot3([x1 x2], [y1 y2], [z1 z2]);
        end
    end

    axis([-50 150 -100 100]);
    grid on
    hold off

    %% Plot tracked points
    subplot(2,2,2);
    title('Tracked points');
    xlabel('x');
    ylabel('y');
    zlabel('z');
    hold on

    for i=1:length(XYZ3D)
        plot3(XYZ3D(i,1),XYZ3D(i,2),XYZ3D(i,3),'*');
    end

    for i=1:(length(XYZ3D)-1)
        x1 = XYZ3D(i,1);
        y1 = XYZ3D(i,2);
        z1 = XYZ3D(i,3);

        for j=(i+1):length(XYZ3D)
            x2 = XYZ3D(j,1);
            y2 = XYZ3D(j,2);
            z2 = XYZ3D(j,3);
            plot3([x1 x2], [y1 y2], [z1 z2]);
        end
    end

    axis([-100 100 -200 0]);
    grid on
    hold off

    %% IR image
    subplot(2,2,3);
    imshow(imgIR)
    hold on
    plot(pointsXY(:,1),pointsXY(:,2),'r*')
    hold off

    %% Depth image
    subplot(2,2,4);
    imshow(imgD,'DisplayRange',[300 5000]);
    hold on
    plot(pointsXY(:,1),pointsXY(:,2),'r*')
    hold off
end

%% Length Head Points
cntr = 1;
for i=1:3
    x1 = headPoint(i,1);
    y1 = headPoint(i,2);
    z1 = headPoint(i,3);
    
    for j=(i+1):4
        x2 = headPoint(j,1);
        y2 = headPoint(j,2);
        z2 = headPoint(j,3);
        
        distanceHead(cntr) = ALGdistancePTP([x1 y1 z1], [x2 y2 z2]);
        cntr = cntr+1;
    end
end

distanceHead = sort(distanceHead);

%% Length Tracked Points
cntr = 1;
for i=1:(length(XYZ3D)-1)
    x1 = XYZ3D(i,1);
    y1 = XYZ3D(i,2);
    z1 = XYZ3D(i,3);
    
    for j=(i+1):length(XYZ3D)
        x2 = XYZ3D(j,1);
        y2 = XYZ3D(j,2);
        z2 = XYZ3D(j,3);
        
        distance3D(cntr) = ALGdistancePTP([x1 y1 z1], [x2 y2 z2]);
        cntr = cntr+1;
    end
end

distance3D = sort(distance3D);

%% Analyze
difference = abs(distanceHead-distance3D);
display([distanceHead;distance3D;difference]);

min(difference)