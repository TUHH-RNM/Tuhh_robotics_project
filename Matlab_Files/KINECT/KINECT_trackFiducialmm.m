function [ pointsmm ] = KINECT_trackFiducialmm( imgIR,imgD,varargin )
%KINECT_trackFiducialmm - Tracks the fiducials in a Kinect image as
%   coordinates given in mm.
%
%   As coordinates, the center of the fiducials are given back in mm in
%   respect to the Kinect. To filter out noise, the scan area in the 
%   picture can be changed. Also the maximum distance from the camera to  
%   the furthest trackable point can be specified.
%
%   Example:
%   KINECT_trackFiducialPixel(imgIR,imgD,'scanArea',[200
%   100],'maxDist',2000);
%
%   The scanArea are specified in pixel and [y x], the distance is given in
%   mm.
%
%   Info:           Preallocation has to be added
%   Designed by:    Mirko Schimkat
%   Date created:   19.06.2016
%   Last modified:  11.07.2016
%   Change Log:  Corrected the assignment from IntrinsicMatrix to Px and
%                Py; Nasser Attar



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
        
        numFiducials    = kin.numFiducials  ;
        cp              = kin.cp            ;
        scanArea        = kin.scanArea      ;
        minDist         = kin.minDist       ;
        maxDist         = kin.maxDist       ;
        threshold       = kin.threshold     ;
        pixelSizeMin    = kin.pixelSizeMin  ;
        pixelSizeMax    = kin.pixelSizeMax  ;
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
        pixelSizeMin = varargin{i+1};
    elseif strcmp(varargin{i},'pixelSizeMin')
        pixelSizeMax = varargin{i+1};
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

% imgBW = flip(imgBW,1);

s = regionprops(imgBW,'Area','BoundingBox','centroid');
j = 1;

Z3D = [];
xp  = [];
yp  = [];

for i=1:numel(s) 
    if (pixelSizeMin <= s(i).Area) &&  (s(i).Area <= pixelSizeMax)
        % Centroid of point
        xp(j) = s(i).Centroid(1);
        yp(j) = s(i).Centroid(2);
        
        % get depth
        x_start     = floor(s(i).BoundingBox(1));
        y_start     = floor(s(i).BoundingBox(2));
        
        x_length    = s(i).BoundingBox(3)+1;
        y_length    = s(i).BoundingBox(4)+1;

        d_up    =   imgD(y_start                        ,x_start:x_start+x_length   );
        d_down  =   imgD(y_start+y_length               ,x_start:x_start+x_length   );
        d_left  =   imgD(y_start+1:y_start+y_length-1   ,x_start                    );
        d_right =   imgD(y_start+1:y_start+y_length-1   ,x_start+x_length           );
        
        d_elements = [d_up'; d_down'; d_left; d_right];
        d_elements(d_elements==0) = [];
        Z3D(j) = round(sum(d_elements)/length(d_elements));
        
        j = j + 1;
    end

end

%% Convert Pixels to mm
if(size(Z3D,2) > numFiducials)
    error('Distortions destroyed the measurement');
end

if isempty(Z3D) || isempty(xp) || isempty(yp)
    error('Points missing');
end

Z3D = double(Z3D);
IntrinsicMatrix = cp.IntrinsicMatrix';
mx = IntrinsicMatrix(1,1);
my = IntrinsicMatrix(2,2);
Px = IntrinsicMatrix(1,3);
Py = IntrinsicMatrix(2,3);

for i=1:length(xp)
    pointsmm(i,1) = (xp(i)-Px)*Z3D(i)/mx;
    pointsmm(i,2) = (yp(i)-Py)*Z3D(i)/my;
end
pointsmm(:,3) = Z3D';

if roundVar
    pointsmm = round(pointsmm);
end
end