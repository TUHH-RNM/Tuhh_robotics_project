function pc = createCloud(imgDepth, cameraParams)
imgRes = size(imgDepth);
imgDepth = double(imgDepth);
[imgDepth, ~] = undistortImage(imgDepth, cameraParams, 'nearest');
imgDepth(imgDepth==0) = NaN;
[xx, yy] = meshgrid(0:imgRes(2)-1, 0:imgRes(1)-1);
pp = cameraParams.PrincipalPoint;
fl = cameraParams.FocalLength;
XX = (xx - pp(1)).*imgDepth./fl(1);
YY = (yy - pp(2)).*imgDepth./fl(2);
pc = pointCloud(cat(3,XX,YY,imgDepth));