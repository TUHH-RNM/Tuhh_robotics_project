function [ T ] = KINECT_getPosition( trcPoints, refPoints, varargin )
%KINECT_getPosition - Gives back the rotation and translation of the trackt
%   object, defined in the ini file.
%
%   The tracked Points have to be given in mm, if cp is not given as an
%   varargin. As soon as cp is given as a varargin, it is considered, that
%   the trackedPoints are given in mm
%
%   BETA STATUS
%   
%   Info:           - Generate the coord system of the tracked points,
%                   - Rotate the coord system to the normal x,y,z axes
%   Designed by:    Mirko Schimkat
%   Date created:   02.07.2016
%   Last modified:  02.07.2016
%   Change Log:

%% Parameters
pointsInPixel = false;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'cp')
        cp = varargin{i+1};
        pointsInPixel = true;
    end
end

%% Calculations
trcPoints           = KINECT_identifyFiducials(refPoints,trcPoints);    % Sort Point
[trcCoord,trcBase]  = ALGcreateCoordinates(trcPoints);                  % Create coordinate system

%% Calculate translation
trans = trcBase;

%% Create Matrix

T = [[trcCoord trans'];[0 0 0 1]];

end

