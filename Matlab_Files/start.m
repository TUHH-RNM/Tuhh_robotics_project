%% Add folders
addpath('UR5');
addpath('TRS');
addpath('ALG');

%% Connect to robot
robObj = UR5connectRobot('192.168.56.101','DispOn');