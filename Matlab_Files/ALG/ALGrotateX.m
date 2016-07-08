function [ Rx ] = ALGrotateX( degree )
%ALGrotateMatrix - Creates a rotation matrix around x.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   06.06.2016
%   Last modified:  06.06.2016
%   Change Log:

Rx =   [1   0           0           ;
        0   cosd(degree) -sind(degree)  ;
        0   sind(degree)  cosd(degree) ];
end
