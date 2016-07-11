function [imgD,imgIR,acquireTime] = KINECT_getSynchronousImages(kin)
% KINECT_GETSYNCHRONOUSIMAGES returns one depth image and one IR image which have been taken, simultanously
%
%    Author: Nasser Attar
%    Date created: 11.07.2016
%    Last modified: 11.07.2016
%    Change Log:

kinObj = kin.KINECT;
vidIR   = kinObj.vidIR;
vidDp   = kinObj.vidDepth;
vidIR.FramesPerTrigger = 1;
vidDp.FramesPerTrigger = 1;

% Acquire Images
start([vidIR vidDp]);
framesAcqIR = 0;
framesAcqDp = 0;
acquireTimer = tic;
while ~(framesAcqDp > 0 && framesAcqIR > 0)
    framesAcqDp = get(vidDp,'FramesAcquired');
    framesAcqIR = get(vidIR,'FramesAcquired');
end
acquireTime = toc(acquireTimer);
imgD    = getdata(vidDp);
imgIR   = getdata(vidIR);

end