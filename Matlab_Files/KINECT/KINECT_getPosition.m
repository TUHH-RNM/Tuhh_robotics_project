function [ T, visability ] = KINECT_getPosition( kin, varargin )
%KINECT_getPosition - Gives back the rotation and translation of the trackt
%   object, defined in the ini file.
%
%   BETA STATUS
%   
%   Info:           - Generate the coord system of the tracked points,
%                   - Rotate the coord system to the normal x,y,z axes
%   Designed by:    Mirko Schimkat
%   Date created:   02.07.2016
%   Last modified:  04.07.2016
%   Change Log:

%% Parameters


%% Varargin
% for i=1:numel(varargin)
%     if strcmp(varargin{i}, 'pointsInPixel')
%         pointsInPixel = true;
%     end
% end

try
    %% Get image from KINECT
    [vidDp, vidIR] = KINECT_startImage( kin.KINECT );
    while(~KINECT_imageReady(vidDp,vidIR))
    end
    [imgD, imgIR] = KINECT_getImages(vidDp,vidIR);

    %% Track and identify fiducials
    pointsmm	= KINECT_trackFiducialmm( imgIR,imgD,'kinObj',kin);
    pointsmm   	= KINECT_identifyFiducials(kin.refPoints,pointsmm);

    %% Calculations
    [trcCoord,trcBase]  = ALGcreateCoordinates(pointsmm);                  % Create coordinate system

    %% Calculate translation
    trans = trcBase;

    %% Create Matrix

    T = [[trcCoord trans'];[0 0 0 1]];
    visability = true;
    
catch 
    T = eye(4);
    visability = false;
end

end

