function T_K_M = KINECT_getMarkerFrameHMT(kin)
% KINECT_GETMARKERFRAMEHMT gives back the HMT from the marker frame to the Kinect camera
%
%    Author: Nasser Attar
%    Date created: 11.07.2016
%    Last modified: 11.07.2016
%    Modified:  

% Make a Depth and IR picture of with Kinect. These pictures must be taken
% at the exact same time
[imgD,imgIR,~] = KINECT_getSynchronousImages(kin);

% Determine the positions of the markerpoints relative to the Kinect
% coordinate system.
markerPoints = KINECT_trackFiducialmm(imgIR,imgD);
end