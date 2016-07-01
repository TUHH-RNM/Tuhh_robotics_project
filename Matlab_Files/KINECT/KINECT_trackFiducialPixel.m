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
picArea     = size(imgIR);
scanArea    = [200 200];    % y x

max_distance = 2000;    
thresh  = .9;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'scanArea')
        scanArea = varargin{i+1};
    end
    if strcmp(varargin{i}, 'maxDist')
        max_distance = varargin{i+1};
    end
end

%% Calculations
pointAreaMin = 6 * 6;
pointAreaMax = 2 * 2;

scanBoarders = round((picArea - scanArea)./2);

%% Image processing
imgBW                               = im2bw(imgIR,thresh);	% Convert to binary
imgBW(imgD > max_distance)          = 0;                    % Delete all areas with distance > max_distance
imgBW(:,1:scanBoarders(2))          = 0;                    % Cut left side
imgBW(:,end-scanBoarders(2):end)    = 0;                    % Cut right side
imgBW(1:scanBoarders(1),:)          = 0;                    % Cut upper side
imgBW(end-scanBoarders(1):end,:)    = 0;                    % Cut lower side

s = regionprops(imgBW,'Area','centroid');
j = 1;

for i=1:numel(s) 

    if (s(i).Area < pointAreaMin) &&  (s(i).Area > pointAreaMax)
        pointsXY(j,:) = s(i).Centroid;
        j = j + 1;
    end

end

end

