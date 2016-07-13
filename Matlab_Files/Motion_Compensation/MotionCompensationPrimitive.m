function MotionCompensationPrimitive(robObj,cameraObj,X,Y,T_C_H_des,camFlag,rtFlag,varargin)
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

% Get the HMT from the Head to the Camera
if strcmp(camFlag,'kinect')
    [T_TS_H,visibility] = KINECT_getMarkerFrameHTM(cameraObj,'headFrame');
elseif strcmp(camFlag,'atrcsys')
    [T_TS_H,visibility,~] = cameraObj.getTransformMatrix();
end
if ~visibility
    warning('Head is not visible\n')
    return
end
 Z = Y*T_TS_H*invertHTM(T_C_H_des);
% Get the target HMT from Endeffector to Base to achieve the desired HMT
% from Head to camera (T_C_H_des)
T_B_E_des = Z*invertHTM(X);

row1 = num2str(T_B_E_des(1,:));
row2 = num2str(T_B_E_des(2,:));
row3 = num2str(T_B_E_des(3,:));

% Move robot to the desired pose. This moving should be done with a function 
% which also features collision detection
if rtFlag
    command = ['MoveRTHomRowWiseStatus ' row1,' ',row2,' ',row3,' ','noToggleHand noToggleElbow noToggleArm'];
else
    command = ['MoveMinChangeRowWiseStatus ' row1,' ',row2,' ',row3,' ','noToggleHand noToggleElbow noToggleArm'];
end
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