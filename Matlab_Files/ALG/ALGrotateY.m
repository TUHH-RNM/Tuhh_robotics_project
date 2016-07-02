function [ Ry ] = ALGrotateY( degree )
%ALGrotateMatrix - Creates a rotation matrix around y.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   06.06.2016
%   Last modified:  06.06.2016
%   Change Log:

Ry =   [cosd(degree)	0 	sind(degree)	;
      	0               1	0               ;
       -sind(degree)	0 	cosd(degree) ]  ;
end