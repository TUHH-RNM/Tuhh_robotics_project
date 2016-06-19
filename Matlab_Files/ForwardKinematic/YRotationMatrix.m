function Ry = YRotationMatrix(angle)
% YROTATIONMATRIX computes the elementary rotation matrix over the y-axis
%
%    Author: Nasser Attar
%    Created: 2016-06-18
%    Modified: 2016-06-18
%    Change Log:

Ry = [cos(angle) 0 sin(angle);
      0 1 0;
      -sin(angle) 0 cos(angle)];
% End of function
end