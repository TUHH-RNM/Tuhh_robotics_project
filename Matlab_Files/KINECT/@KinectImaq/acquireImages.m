function [imgAll, timestamps, metadata] = acquireImages(vidSrc, requestedFrames)
% acquireImages  static method

if requestedFrames<60
    wt = 1;
elseif requestedFrames < 120
    wt = requestedFrames/60;
else
    wt = 2;
end

vidSrc.FramesPerTrigger = requestedFrames;
start(vidSrc);
framesAcq = get(vidSrc,'FramesAcquired');

msg = '';
framesAcqPrev = framesAcq;
tt = 0;
while framesAcq < requestedFrames
     pause(wt);
    framesAcq = get(vidSrc,'FramesAcquired');
    fprintf(repmat('\b', 1, length(msg)));
    msg = sprintf('Frames acquired: %d\n', framesAcq);
    fprintf(msg);
    if framesAcqPrev == framesAcq
        tt = tt + wt;
        pause(wt);
        framesAcq = get(vidSrc,'FramesAcquired');
        if tt>10
            warning('Waiting time elapsed. Restarting Kinect source.');
            tt = 0;
            delete(vidSrc);
            vidSrc = videoinput(KinectImaq.AdaptorName,vidSrc.DeviceID);
            framesAcq = 0;
            start(vidSrc);
        end
    else
        tt = 0;
    end
    framesAcqPrev = framesAcq;
end

[imgAll,timestamps,metadata] = getdata(vidSrc);
imgAll = squeeze(imgAll);

end