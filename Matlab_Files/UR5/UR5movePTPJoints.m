function [ out ] = UR5movePTPJoints(obj, matJoints )
%UR5movePTPJoints(obj, matJoints ) - Moves the robot in PTP-mode to a new joint position
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

%% Error handling
if numel(matJoints) ~= 6
    error('Missmatch for matJoints');
end

%% Convert matJoints into string
command = 'MovePTPJoints';
for i=1:6
    command = [command ' ' num2str(matJoints(i))];
end

out = UR5sendCommand(obj,command);

end

