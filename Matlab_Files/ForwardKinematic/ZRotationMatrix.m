function Rz = ZRotationMatrix(angle,varargin)
% ZROTATIONMATRIX computes the elementary rotation matrix over the z-axis
%
%    Author: Nasser Attar
%    Created: 2016-06-18
%    Modified: 2016-06-18
%    Change Log:

Rz = [cos(angle) -sin(angle) 0;
      sin(angle) cos(angle) 0;
      0 0 1];


% End of function