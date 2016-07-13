function [ kin ] = KINECT_initialize( trackObj, serialNr, varargin )
%KINECT_initialize - Initialize the KINECT system for the functions
%   KINECT_gePosition
%
%
%   Info:           
%   Designed by:    Mirko Schimkat
%   Date created:   04.07.2016
%   Last modified:  04.07.2016
%   Change Log:


%% Parameters
scanArea        = [200 200];    % y x
minDist         = 100;
maxDist         = 2000;    
threshold       = .9;
pixelSizeMin    = 6 * 6;
pixelSizeMax    = 2 * 2;
roundVar        = false;
numFiducials    = 0;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'scanArea')
        scanArea = varargin{i+1};
    elseif strcmp(varargin{i}, 'minDist')
        minDist = varargin{i+1};
    elseif strcmp(varargin{i}, 'maxDist')
        maxDist = varargin{i+1};
    elseif strcmp(varargin{i},'threshold')
        threshold = varargin{i+1};
    elseif strcmp(varargin{i},'pixelSizeMax')
        pixelSizeMax = varargin{i+1};
    elseif strcmp(varargin{i},'pixelSizeMin')
        pixelSizeMin = varargin{i+1};
    elseif strcmp(varargin{i},'round')
        roundVar = true;
    end
end

%% Load reference points
if strcmp(trackObj,'coil')
    refPoints       = KINECT_importTrackingIni('KINECT/coil.ini');
    numFiducials    = 5;
elseif strcmp(trackObj,'head')
    refPoints = KINECT_importTrackingIni('KINECT/head.ini');
    numFiducials    = 4;
else
    error('Reference Model not in system');
end

%% Load camera data
if serialNr == 033870745147
    load('KINECT\@KinectImaq\IRKinectParams033870745147.mat');
elseif serialNr == 502442443142
    load('KINECT\@KinectImaq\IRKinectParams502442443142.mat')
elseif serialNr == 999999999999
    load('KINECT\@KinectImaq\IRKinectParams999999999999.mat');
end

%% Start Kinect
kin.KINECT = KinectImaq(serialNr);

%% Save other informations
kin.cp              = cp;
kin.refPoints       = refPoints;
kin.numFiducials    = numFiducials;
kin.scanArea        = scanArea;
kin.minDist         = minDist;
kin.maxDist         = maxDist;
kin.threshold       = threshold;
kin.pixelSizeMax    = pixelSizeMax;
kin.pixelSizeMin    = pixelSizeMin;
kin.roundVar        = roundVar;

end

