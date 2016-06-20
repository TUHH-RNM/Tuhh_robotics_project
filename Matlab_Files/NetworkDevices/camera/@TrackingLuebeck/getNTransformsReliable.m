function [TAll,timestamps] =  getNTransformsReliable(self, N )
%getNTransformsReliable Returns always a transformmatrix which was
%                               read by the cameras
%   Can be used everytime when we have to calibrate by hand

TAll = zeros(4,4,N);
timestamps = zeros(N,1);
for idx = 1:N
    [TAll(:,:,idx), timestamps(idx)] = self.getTransformMatrixReliable();    
end

