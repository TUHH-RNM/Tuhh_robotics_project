function pc = createIRCloud(imgDepth,imgIR,cameraParams)

pc = KinectImaq.createCloud(imgDepth,cameraParams);
irRes = size(imgIR);
cmap = colormap('hsv');
extIR = double(unique(sort(imgIR(:))));
clr = double(imgIR) - extIR(1);
clr = round(63 * clr ./ extIR(end-1))+1;
clr(clr>64) = 64;
clrC = uint8(255*reshape(cmap(clr,:), irRes(1), irRes(2), 3));
pc.Color = clrC;
end   %function end