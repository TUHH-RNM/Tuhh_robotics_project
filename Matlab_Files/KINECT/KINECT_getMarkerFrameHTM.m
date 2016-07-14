function T_K_M = KINECT_getMarkerFrameHTM(kin,varargin)
% KINECT_GETMARKERFRAMEHMT gives back the HMT from the marker frame to the Kinect camera
%
%    Author: Nasser Attar
%    Date created: 11.07.2016
%    Last modified: 11.07.2016
%    Modified:  

% Make a Depth and IR picture of with Kinect. These pictures must be taken
% at the exact same time
[imgD,imgIR,acquireTime] = KINECT_getSynchronousImages(kin); %#ok<ASGLU>

% Determine the positions of the markerpoints relative to the Kinect
% coordinate system.
markerPoints_K = KINECT_trackFiducialmm(imgIR,imgD,'cp',kin.cp,'round');
% Sort the marker points from point 1 to point 4
markerPoints_K = KINECT_identifyFiducials(kin.refPoints,markerPoints_K);

% Compute the location vectors of the marker points in the marker frame
% with respect to the Kinect frame. It's assumed that point 1 is always 
% also the origin of the marker frame.
locVectors_K = zeros(3);
locVectors_K(:,1) = markerPoints_K(2,:) - markerPoints_K(1,:);
locVectors_K(:,2) = markerPoints_K(3,:) - markerPoints_K(1,:);
locVectors_K(:,3) = markerPoints_K(4,:) - markerPoints_K(1,:);

% The same location vectors but now with respect to the marker frame
locVectors_M = kin.refPoints(2:4,:)';

% The rotation matrix R_K_M follows the equation:
% locVectors_K = R_K_M*locVectors_M
% Therefore, to compute R_K_M a right division takes place
R_K_M = locVectors_K/locVectors_M;

% Orthogonalize the matrix R_K_M. In the below code it's done with
% QR-orthogonalization, but there might be a more optimal way
[R_K_M,~] = qr(R_K_M);

% Normalize the columns of R_K_M
R_K_M(:,1) = R_K_M(:,1)/sqrt(sum(R_K_M(:,1).^2));
R_K_M(:,2) = R_K_M(:,2)/sqrt(sum(R_K_M(:,2).^2));
R_K_M(:,3) = R_K_M(:,3)/sqrt(sum(R_K_M(:,3).^2));

T_K_M = [R_K_M,markerPoints_K(1,:)';0 0 0 1];

end