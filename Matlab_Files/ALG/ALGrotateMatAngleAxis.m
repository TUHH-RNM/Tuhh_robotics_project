function [ R ] = ALGrotateMatAngleAxis( angle, axis )
%ALFrotateMatrix - Creates a rotation matrix depending on the rotation axis
%   and the rotation angle
%
%   Eg.:
%   R = ALGrotateMatAngleAxis(90,[3 0 0]);
%   R contains a rotation matrix about the x axis by 90°
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   30.06.2016
%   Last modified:  30.06.2016
%   Change Log:

axis = axis / ALGlenghtVec(axis);

c = cosd(angle);
s = sind(angle);
t = 1 - c;
x = axis(1);
y = axis(2);
z = axis(3);

R(1,:) = [(t*x*x + c)   (t*x*y - z*s) (t*x*z + y*s)];
R(2,:) = [(t*x*y + z*s)	(t*y*y + c)	  (t*y*z - x*s)];
R(3,:) = [(t*x*z - y*s)	(t*y*z + x*s) (t*z*z + c)  ];

end

