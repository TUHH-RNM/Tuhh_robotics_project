function Rx = XRotationMatrix(angle)
% XROTATIONMATRIX computes the elementary rotation matrix over the x-axis
%
%    Author: Nasser Attar
%    Created: 2016-06-18
%    Modified: 2016-06-18
%    Change Log:

Rx = [1 0 0;
      0 cos(angle) -sin(angle);
      0 sin(angle) cos(angle)];

% End of function
end