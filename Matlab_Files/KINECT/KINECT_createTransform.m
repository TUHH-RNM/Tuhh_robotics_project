function [ T ] = KINECT_createTransform( refPoints,trcPoints )
%KINECT_CREATETRANSFORM Summary of this function goes here
%   Detailed explanation goes here

%% Translation
trans = refPoints(1,:) - trcPoints(1,:);

%% Rotation
% for i = 2:4
%     refVec = refPoints(i,:) - refPoints(1,:);
%     trcVec = trcPoints(i,:) - trcPoints(1,:);
% 
%    	refVec = refVec/ALGlenghtVec(refVec);
%    	trcVec = trcVec/ALGlenghtVec(trcVec);
%         
%    	rotAx(i-1,:)  = cross(refVec,trcVec);
%    	anglCos  	  = dot(refVec,trcVec);
%    	angle(i-1)    = acosd(anglCos);
% end
refVec = refPoints(2,:) - refPoints(1,:);
trcVec = trcPoints(2,:) - trcPoints(1,:);

refVec = refVec/ALGlenghtVec(refVec);
trcVec = trcVec/ALGlenghtVec(trcVec);

rotAx   = cross(trcVec,refVec);
anglCos	= dot(refVec,trcVec);
angle 	= acosd(anglCos);

%% Create Matrix
rotation = ALGrotateMatAngleAxis(angle(1), rotAx(1,:));

% T(1:3,1:3)  = rotation;
% T(1:3,4)    = trans;
% T(4,:)      = [0 0 0 1];

%% Debugg
T = eye(3);
T(4,:) = [0 0 0];
T(:,4) = [trans';1];
end

