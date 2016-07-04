%% Addpath
addpath('KinectImaq');

%% Toolbox
imaqtool

%% Instatiate kinect object
if ~exist('kin')
    kin = KinectImaq(999999999999);
end
