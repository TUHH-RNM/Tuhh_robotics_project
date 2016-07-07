function [ pointsXY ] = KINECT_trackFiducialPixel( imgIR,imgD,varargin )
%KINECT_trackFiducialPixel - Tracks the fiducials in a Kinect image as
%   pixel coordinates
%
%   As coordinates, the center of the fiducials are given back in pixels in
%   respect to the imgIR. To filter out noise, the scan area in the picture
%   can be changed. Also the maximum distance from the camera to the 
%   furthest trackable point can be specified.
%
%   Example:
%   KINECT_trackFiducialPixel(imgIR,imgD,'scanArea',[200
%   100],'maxDist',2000);
%
%   The scanArea are specified in pixel and [y x], the distance is given in
%   mm.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   19.06.2016
%   Last modified:  19.06.2016
%   Change Log:



%% Parameters
scanArea        = [200 200];    % y x
minDist         = 100;
maxDist         = 2000;    
threshold       = .9;
pixelSizeMax    = 6 * 6;
pixelSizeMin    = 2 * 2;
roundVar        = false;
numFiducials    = 4;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i},'cp')
        cp = varargin{i+1};
    elseif strcmp(varargin{i},'kinObj')
        kin = varargin{i+1};
        
        scanArea        = kin.scanArea      ;
        minDist         = kin.minDist       ;
        maxDist         = kin.maxDist       ;
        threshold       = kin.threshold     ;
        pixelSizeMax    = kin.pixelSizeMax  ;
        pixelSizeMin    = kin.pixelSizeMin  ;
        roundVar        = kin.roundVar      ;
    elseif strcmp(varargin{i}, 'scanArea')
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
    elseif strcmp(varargin{i},'numFiducials')
        numFiducials = varargin{i+1};
    end
end


%% Calculations
picArea    	 = size(imgIR);
scanBoarders = round((picArea - scanArea)./2);

%% Image processing
imgBW                                   = im2bw(imgIR,threshold);	% Convert to binary
imgBW((imgD < minDist) & (imgD ~= 0))   = 0;
imgBW(imgD > maxDist)                   = 0;                        % Delete all areas with distance > max_distance
imgBW(:,1:scanBoarders(2))              = 0;                        % Cut left side
imgBW(:,end-scanBoarders(2):end)        = 0;                        % Cut right side
imgBW(1:scanBoarders(1),:)              = 0;                        % Cut upper side
imgBW(end-scanBoarders(1):end,:)        = 0;                        % Cut lower side

s = regionprops(imgBW,'Area','centroid');
j = 1;

pointsXY = [];
for i=1:numel(s) 

    if (s(i).Area < pixelSizeMax) &&  (s(i).Area > pixelSizeMin)
        pointsXY(j,:) = s(i).Centroid;
        j = j + 1;
    end

end

end

