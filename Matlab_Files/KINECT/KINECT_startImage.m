function [vidDp, vidIR] = KINECT_startImage( kin )
%KINECT_startImage - Triggers the KINECT to take a IR and a depth image at
%   the same time.
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

vidIR   = kin.vidIR;
vidDp   = kin.vidDepth;
vidIR.FramesPerTrigger = 1;
vidDp.FramesPerTrigger = 1;

%% Acquire images
tic
start([vidIR vidDp]);


end

