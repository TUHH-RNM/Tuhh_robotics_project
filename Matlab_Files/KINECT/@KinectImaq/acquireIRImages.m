function [imgIRAll, timestamps, metadata] = acquireIRImages(self, requestedFrames)
% acquireIRImages  
%   [imgIRAll, timestamps, metadata] =
%   kin.acquireIRImages(requestedFrames);

[imgIRAll, timestamps, metadata] = KinectImaq.acquireImages(self.vidIR, requestedFrames);
% imgIRAll = im2double(imgIRAll);
imgIRAll = double(imgIRAll)./(2^16-1);
imgIRAll = imgIRAll ./ (0.08 * 3);
imgIRAll = min(1,imgIRAll);
imgIRAll = max(0.01, imgIRAll);
if self.mirror
    imgIRAll = fliplr(imgIRAll);
end
end