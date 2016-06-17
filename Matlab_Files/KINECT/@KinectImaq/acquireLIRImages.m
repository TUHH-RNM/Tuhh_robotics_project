function [imgLIRAll, timestamps, metadata] = acquireLIRImages(self, requestedFrames)
% acquireLIRImages  
%   [imgLIRAll, timestamps, metadata] =
%   kin.acquireLIRImages(requestedFrames);

[imgLIRAll, timestamps, metadata] = KinectImaq.acquireImages(self.vidLIR, requestedFrames);
imgLIRAll = im2double(imgLIRAll);
if self.mirror
    imgLIRAll = fliplr(imgLIRAll);
end
end