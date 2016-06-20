function [T,timestamp] =  getTransformMatrixReliable(self)
%getTransformMatrixReliable Returns always a transformmatrix which was
%                               read by the cameras
%   Can be used everytime when we have to calibrate by hand

whileflag = 1;
while whileflag == 1
    [T,visFlag,timestamp] =  self.getTransformMatrix();
    if ( ~visFlag || sum(T(:)) == 1 || sum(T(:)) == 4 )
        disp('Sorry, could not see the locator, please try again in 100ms!');
        pause(0.1);
    else
        whileflag = 0;
    end
end

end

