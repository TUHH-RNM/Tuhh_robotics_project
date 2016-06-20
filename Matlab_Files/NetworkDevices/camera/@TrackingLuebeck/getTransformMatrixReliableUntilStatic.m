function [T,visFlag,timestamp] =  getTransformMatrixReliableUntilStatic(self, maxTries )
%getTransformMatrixReliableLimTries Returns always a transformmatrix which was
%                               read by the cameras
%   Can be used everytime when we have to calibrate by hand

[T,visFlag,timestamp] =  self.getTransformMatrixReliableLimTries(maxTries);
if ~visFlag
    return;
end
whileflag = true;
while whileflag
    Tprev = T;
    pause(0.5);
    [T,visFlag,timestamp] =  self.getTransformMatrixReliableLimTries(maxTries);
    whileflag = (sum(abs(T(:)-Tprev(:))) > 1e-1);
end

end

