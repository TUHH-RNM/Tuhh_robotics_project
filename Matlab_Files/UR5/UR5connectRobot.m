function [ obj ] = UR5connectRobot( IP, varargin )
% CONNECTROBOT - Creates a TCPIP object which is connected to the robot
%   IP is the IP of the robot, for example: '192.168.56.101'
%   
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   26.05.2016
%   Last modified:  27.05.2016
%   Change Log:
%% Parameters
max_time    =   10;
time        =   0;
DispOn      =   false;
port        =   5005;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'DispOn')
        DispOn = true;
    elseif strcmp(varargin{i},'Port')
        port = varargin{i+1};
    end
end

%% Open TCP connection
obj = tcpip(IP,port);
fopen(obj);

%% Read answer from server
% tic
% while(~obj.BytesAvailable && time < max_time)
%     time = toc; % for timeout
% end
% 
% if(time > max_time)
%     error('Timeout');
% end
% 
% output = char(fread(obj,obj.BytesAvailable)');
output = [];

%% Handshake with server
output = [output UR5sendCommand(obj,'Hello Robot')];

%% Display the console text
if(DispOn)
    fprintf(output);
end
end

