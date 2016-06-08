function [ output ] = UR5sendCommand( obj,command )
%UR5sendCommand - Send a command (string) to the UR5 
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:

max_time    =   20;  % time to timeout
time        =   0;

fwrite(obj,command);
tic
while(~obj.BytesAvailable && time < max_time)
    time = toc; % for timeout
end
output = char(fread(obj,obj.BytesAvailable)');

end

