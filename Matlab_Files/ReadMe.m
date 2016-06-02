% Tutorial:
% 1. Start linux enviroment
% 2. Start simulation program for UR5 (start-ursim.sh)
% 3. Click on "run"
% 4. Click on the tap "Move" to see the robot
% 5. Start the server "rob6server -a 127.0.0.1 -b127.0.0.1 ur5"
% 6. Click on "continuous"
% 7. Step throug skript

% Add the pathes of the needed folders
addpath('UR5');

% Start Server
obj = UR5connectRobot('192.168.56.101','DispOn');

% Get angulars from robot
angles1 = UR5getPositionJoints(obj);

% Set speed
UR5setSpeed(obj,120);

% Set new angulars
angles2 = [0 0 0 0 0 0];
UR5movePTPJoints(obj,angles2)

% Disconect from server
UR5disconnectRobot(obj)