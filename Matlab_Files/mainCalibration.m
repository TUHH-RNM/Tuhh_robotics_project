%% Connect to the Robserver and tracking device
addFolders();
robObj = UR5connectRobot('134.28.45.95','DispOn');
trackObj = TrackingLuebeck('134.28.45.17', 5000, 'coil', 'FORMAT_MATRIXROWWISE');

%% Load the neccessary data and set the variables
load 'DenHartParameters';
robotSpeed = 10;
measurements = 20;
[robotPoses, trackedPoses] = HandEyeCalibrationCollectingData...
    (robObj, trackObj, DenHartParameters, robotSpeed, measurements);

%% Calculate X and Y
M = TrobAll;
N = TkinAll;
[X,Y] = HandEyeCalibrationCalculatingXY(M,N);  

%% Calculating the max deviations between 
% the robot-marker and tracker-marker transformations 
initialVars = who();
initialVars(numel(initialVars)+1) = cellstr('maxDiff');
diff = zeros(4,4,1);
maxDiff = zeros(4,4,1);

for i=1:50
    testX = M(:,:,i)*X;
    testY = Y*N(:,:,i);
    diff(:,:,i) = testX - testY;    
    
    for k=1:3
        for l=1:4
            if abs(maxDiff(k,l)) < abs(diff(k,l,i))
                maxDiff(k,l) = diff(k,l,i);
            end
        end
    end
end
clearvars('-except',initialVars{:});