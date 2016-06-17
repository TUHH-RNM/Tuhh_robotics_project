function imgDepthMean = averageDepthImages(imgDepthAll)
imgDepthAll = double(imgDepthAll);
imgDepthAll(imgDepthAll==0) = NaN;
imgDepthMean = mean(imgDepthAll,3);
end   %function end