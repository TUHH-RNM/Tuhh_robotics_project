function MotionCompensationPrimitive(robObj,cameraObj,X,Y,T_C_H_des,DenHartParam,varargin)
% MOTIONCOMPENSATIONPRIMITIVE moves the robot such that T_C_H_des is the HMT from head to coil
%
%   
%   Info:           cameraObj: object for the used tracking system
%                              (Atrcsys or Kinect)
%                   X: HMT from coil to head
%                   Y: HMT from tracking system to coil
%                   T_C_H_des: Desired HMT from head to coil
%   Designed by:    Nasser Attar
%   Date created:   30.06.2016
%   Last modified:  30.06.2016
%   Change Log:    

rtMode = false;
camFlag = 'atrcsys';
headFrame = false;
for i = 1:numel(varargin)
    if strcmp(varargin{i},'rtMode')
        rtMode = true;
    elseif strcmp(varargin{i},'kinect')
        camFlag = 'kinect';
    elseif strcmp(varargin{i},'headFrame')
        headFrame = true;
    end
end
% Get the HMT from the Head to the Camera
if strcmp(camFlag,'kinect')
    [T_TS_H,visibility] = KINECT_getMarkerFrameHTM(cameraObj);
elseif strcmp(camFlag,'atrcsys')
    [T_TS_H,visibility,~] = cameraObj.getTransformMatrix();
else
    error('No such camera existent')
end
if ~visibility
    warning('Head is not visible\n')
    return
end

% Ouput the HTM from the head frame (according to the MEG/EEG
% convention) to the Kinect frame
if headFrame
    T_H_M = [0.004056364482707 -0.967455059014186 -0.253010702621596 -54.756751128760129;
             0.956482476316876 -0.070067530666923 0.283252915519113 -76.092549496522793;
            -0.291762597549653 -0.243150168484619 0.925069089991579 80.697550637454697;
             0 0 0 1];
    T_TS_H = T_TS_H*invertHTM(T_H_M);     
end

% Get the target HMT from Endeffector to Base to achieve the desired HMT
% from Head to camera (T_C_H_des)
Z = Y*T_TS_H*invertHTM(T_C_H_des);
T_B_E_des = Z*invertHTM(X);

% Move robot to the desired pose. This moving should be done with a function 
% which also features collision detection
% row1 = num2str(T_B_E_des(1,:));
% row2 = num2str(T_B_E_des(2,:));
% row3 = num2str(T_B_E_des(3,:));
% 
% if rtMode
%     command = ['MoveRTHomRowWiseStatus ' row1,' ',row2,' ',row3,' ','noToggleHand noToggleElbow noToggleArm'];
% else
%     command = ['MoveMinChangeRowWiseStatus ' row1,' ',row2,' ',row3,' ','noToggleHand noToggleElbow noToggleArm'];
% end

[~,~, minAngles ] = TRSAnglesFromTargetPose( robObj, T_B_E_des, DenHartParam);
if rtMode
    command = ['MoveRTJoints ',num2str(minAngles)];
else
    command = ['MovePTPJoints ',num2str(minAngles)];
end


% Give the robot a little break
% pause(0.02);
% Do the movement

output = UR5sendCommand(robObj,command);
if ~strfind(output,'true')
    warning('\nMotion Compensation was not successful\n')
end

% Wait until the joints don't change anymore (robot arrived)
% temp2 = 0;
% while 1
%     temp1 = UR5getPositionJoints(robObj);
%     if isequal(temp1,temp2)
%         break;
%     end
%     temp2 = temp1;
%     pause(0.5);
% end

% End of function
end