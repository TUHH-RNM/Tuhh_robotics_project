function [ out ] = UR5getPositionJoints( obj )
%UR5GETPOSITIONJOINTS - Delivers the six angles of the joints 
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

receive = UR5sendCommand(obj,'GetPositionJoints');
out = UR5str2double(receive,'varCol',6);

end

