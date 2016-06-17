function [  ] = KINECT_showImages( varargin )
%KINECT_showImages - Displays the images in a plot figure
%
%      
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   16.06.2016
%   Last modified:  16.06.2016
%   Change Log:


%% Parameter
DMin = 500;
DMax = 3000;

%% Varargin
for i=1:numel(varargin)
    if strcmp(varargin{i}, 'IR')
        figure;
        imshow(varargin{i+1});
    elseif strcmp(varargin{i}, 'D')
        figure
        imshow(varargin{i+1},'DisplayRange',[DMin DMax]);
    elseif strcmp(varargin{i}, 'color')
        colormap parula;
    elseif strcmp(varargin{i}, 'Dmin')
        DMin = varargin{i+1};
    elseif strcmp(varargin{i}, 'Dmax')
        DMax = varargin{i+1};
    end
end

end

