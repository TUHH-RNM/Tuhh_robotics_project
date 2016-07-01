function [ Rz ] = ALGrotateZ( degree )
%ALFrotateMatrix - Creates a rotation matrix around z.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   06.06.2016
%   Last modified:  06.06.2016
%   Change Log:

Rz =   [cosd(degree)   -sind(degree)  0   ;
        sind(degree)    cosd(degree)  0   ;
        0               0             1  ];
end