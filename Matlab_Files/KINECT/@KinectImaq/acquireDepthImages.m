function [imgDepthAll, timestamps, metadata] = acquireDepthImages(self, requestedFrames)
% acquireDepthImages  
%   [imgDepthAll, timestamps, metadata] =
%   kin.acquireDepthImages(requestedFrames);

[imgDepthAll, timestamps, metadata] = KinectImaq.acquireImages(self.vidDepth, requestedFrames);

if self.mirror
    imgDepthAll = fliplr(imgDepthAll);
end
end