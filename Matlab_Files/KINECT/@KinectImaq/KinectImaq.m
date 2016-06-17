classdef KinectImaq
    %KinectImaq Summary of this class goes here
    %   Detailed explanation goes here
    %   KinectImaq()
    
    properties 
        mirror = true;
        serial = 999999999999;
        irParams;
        irRes;
        rgbRes;
%     end
%     
%     properties (Access = protected)
        vidRGB;
        vidDepth;
        vidIR;
        vidLIR;
    end
    
    properties (Constant)
        AdaptorName = 'kinectv2imaq';
    end
    
    methods (Static)
      [imgAll, timestamps, metadata] = acquireImages(vidSrc, requestedFrames)
      pc = createCloud(imgDepth, cameraParams)
      pc = createIRCloud(imgDepth, imgIR, cameraParams)
      imgDepthMean = averageDepthImages(imgDepthAll)
    end
    
    methods (Access = public)
        % Constructor
        function self = KinectImaq(ser)
            if nargin == 1
                self.serial = ser;
            elseif nargin ~= 0
                error('Wrong number of arguments in the constructor');
            end
            cp = load(['IRKinectParams' sprintf('%012d',self.serial) '.mat']);
            self.irParams = cp.cp;
            self.vidRGB = videoinput(KinectImaq.AdaptorName, 1);
            self.vidDepth = videoinput(KinectImaq.AdaptorName, 2);
            self.vidIR = videoinput(KinectImaq.AdaptorName, 3);
            self.vidLIR = videoinput(KinectImaq.AdaptorName, 4);
            self.irRes = fliplr(get(self.vidIR, 'VideoResolution'));
            self.rgbRes = get(self.vidRGB, 'VideoResolution');
        end
    end
    
end

