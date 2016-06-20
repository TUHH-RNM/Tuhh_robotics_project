classdef TrackingLuebeck < NetworkDevice
    %TrackingLuebeck Summary of this class goes here
    %   Detailed explanation goes here
    %   TrackingLuebeck(ip,port,locatorname,format)
    %   TrackingLuebeck('192.168.1.241',5000,'coil','FORMAT_MATRIXROWWISE')
    
    properties 
    end
    
    methods (Access = public)
        % Constructor
        function self = TrackingLuebeck(ip,port,locatorname,format)
            self@NetworkDevice(ip,port);
            self.sendReceive(sprintf('CM_GETSYSTEM\n'), 0.1);
            self.sendReceive(sprintf('%s\n',locatorname), 0.1);
            self.sendReceive(sprintf('%s\n',format), 0.1);
        end
    end
    
    methods (Access = private)
        %% Disconnects from robot.
        function disconnect(self)
            jtcp('close',self.client);
        end
    end
end

