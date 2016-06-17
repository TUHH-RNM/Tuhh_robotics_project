function [out] = KINECT_takeSnapshot(kin,varargin)
%KINECT_takeSnapshot - Takes a snapshot from the Kinect system.
%
%   With this function three kind of images can be made. 
%   1. Depth image
%   2. Infrared Image
%   3. RGB-Image
%
%   If not other specidied over varargin, the function will return three
%   matrices, [imgD, imgR, imgRGB]. If there are varargin, only the
%   specified pictures will be taken and given back in the descriebed order
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   16.06.2016
%   Last modified:  16.06.2016
%   Change Log:

%% Program
if ~~isempty(varargin)
    %% No parameters
    
    imgD    = kin.acquireDepthImages(1);
    imgIR   = kin.acquireIRImages(1);
    imgRGB  = kin.acquireRGBImages(1);
    out = [imgD, imgIR, imgRGB];
else
    %% Varargin
    imgD    = [];
    imgIR   = [];
    imgRGB  = [];
    number  = 1;
    
    for i=1:numel(varargin)
        if strcmp(varargin{i}, 'Depth')
            imgD    = kin.acquireDepthImages(number);
        elseif strcmp(varargin{i}, 'IR')
            imgIR   = kin.acquireIRImages(number);
        elseif strcmp(varargin{i}, 'RGB')
            imgRGB  = kin.acquireRGBImages(number);
        elseif strcmp(varargin{i}, 'number')
            number = varargin{i+1};            
        end
    end
end

out = [imgD, imgIR, imgRGB];

end