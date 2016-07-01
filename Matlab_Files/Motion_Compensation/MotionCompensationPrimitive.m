function MotionCompensationPrimitive(robObj,cameraObj,X,Y,T_C_H_des,cameraFlag,varargin)
% MOTIONCOMPENSATIONPRIMITIVE moves the robot such that Tch_des is the HMT from head to coil

pause('on')
initialConfig = UR5sendCommand(robObj,'GetStatus');

% Get the HMT from the Head to the Camera
T_TS_H = GetHeadToCameraHMT(cameraObj,cameraFlag);
Z = Y*T_TS_H*invertHTM(T_C_H_des);
% Get the target HMT from Endeffector to Base to achieve the desired HMT
% from Head to camera (T_C_H_des)
T_B_E_des = Z*invertHTM(X);

row1 = num2str(T_B_E_des(1,:));
row2 = num2str(T_B_E_des(2,:));
row3 = num2str(T_B_E_des(3,:));

% Move robot to the desired pose. This moving should be done with enabled
% collision detection in the future
command = ['MoveMinChangeRowWiseStatus ' row1 row2 row3 initialConfig];

if ~strcmp(command,'true')
    warning('\nMotion Compensation was not successful\n')
end

% Wait until the joints don't change anymore (robot arrived)
temp2 = 0;
while 1
    temp1 = UR5getPositionJoints(robObj);
    if isequal(temp1,temp2)
        break;
    end
    temp2 = temp1;
    pause(0.5);
end

% End of function
end