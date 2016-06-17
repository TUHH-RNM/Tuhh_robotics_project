function [imgRGBAll, timestamps, metadata] = acquireRGBImages(self, requestedFrames)
% acquireRGBImages  
%   [imgRGBAll, timestamps, metadata] =
%   kin.acquireRGBImages(requestedFrames);

[imgRGBAll, timestamps, metadata] = KinectImaq.acquireImages(self.vidRGB, requestedFrames);

if self.mirror
    imgRGBAll = fliplr(imgRGBAll);
end
end