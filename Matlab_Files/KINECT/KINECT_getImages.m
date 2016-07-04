function [ imgD,imgIR ] = KINECT_getImages( vidDp,vidIR )
%KINECT_getImages - Downloads the images from the KINECT camera
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

imgD    = getdata(vidDp);
imgIR   = getdata(vidIR);

end

