function T_K_M = KINECT_getMarkerFrameHTM(kin,varargin)
% KINECT_GETMARKERFRAMEHMT gives back the HMT from the marker frame to the Kinect camera
%
%    Author: Nasser Attar
%    Date created: 11.07.2016
%    Last modified: 11.07.2016
%    Modified:  

headFrame = false;
% Search in varargin for additional options
if ~isempty(varargin)
    for i = numel(varargin)
        if strcmp(varargin{i},'headFrame')
            headFrame = true;
        end
    end
end

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

% Ouput the HTM from the head frame (according to the MEG/EEG
% convention) to the Kinect frame
if headFrame
    T_H_M = [0.004056364482707 -0.967455059014186 -0.253010702621596 -54.756751128760129;
             0.956482476316876 -0.070067530666923 0.283252915519113 -76.092549496522793;
            -0.291762597549653 -0.243150168484619 0.925069089991579 80.697550637454697;
             0 0 0 1];
    T_K_M = T_K_M*invertHTM(T_H_M);     
end

end