function [ out ] = KINECT_imageReady( vidDp, vidIR )
%KINECT_imageReady - Returns a true, if images are ready to download,
%   otherwise returns a false.
%
%   To get a whole image, do following steps:
%   1. Trigger KINECT (KINECT_startImage)
%   2. Wait till images are acquired (KINECT_imageReady)
%   3. Get the images (KINECT_getImages)
%
%
%   Info:           
%   Designed by:    Mirko Schimkat
%   Date created:   04.07.2016
%   Last modified:  04.07.2016
%   Change Log:

framesAcqIR = get(vidDp,'FramesAcquired');
framesAcqDp = get(vidIR,'FramesAcquired');
if(framesAcqDp < 1) || (framesAcqIR < 1)
    out = false;
else
    out = true;
end


end