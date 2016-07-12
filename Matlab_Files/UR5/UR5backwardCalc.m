function [ out, config ] = UR5backwardCalc( obj )
% UR5backwardCalc - calculates the six joints angles from the given   
% transformaton matrix and the current configuration using the inverse 
% kinematics 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   16.06.2016
%   Last modified:  19.06.2016
%   Change Log:

%% Given inverse kinematics  
T06SimInMillimeters = UR5getPositionHomRowWise(obj);
T06SimInMillimeters(:,4) = T06SimInMillimeters(:,4);

row1 = num2str(T06SimInMillimeters(1,:));
row2 = num2str(T06SimInMillimeters(2,:));
row3 = num2str(T06SimInMillimeters(3,:));
config = UR5sendCommand(obj,'GetStatus');
command = ['BackwardCalc' ' ' row1 ' ' row2 ' ' row3 ' ' config];

receive = UR5sendCommand(obj,command);
out = UR5str2double(receive,'varCol',6);

end

