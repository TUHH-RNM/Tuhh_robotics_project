function [ out ] = UR5getPositionHomRowWise( obj )
%UR5getPositionHomRowWise - Delivers the six angles of the joints 
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

receive = UR5sendCommand(obj,'GetPositionHomRowWise');
out = UR5str2double(receive,'varCol',4,'varRow',3);
end

