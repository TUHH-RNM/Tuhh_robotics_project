function v = RotationVectorFromRM(R,varargin)
% ROTATIONVECTORFROMHMT computes the corresponding rotation vector from the RotationMatrix R
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

% These formulas for the rotation angle and vector can be found in
% the book "Robotics (Modelling, Planning, Control)" from Silicao
angle = acos((R(1,1) + R(2,2) + R(3,3) - 1)/2);
if angle ~= 0
    r = 1/(2*sin(angle))*[R(3,2) - R(2,3);R(1,3) - R(3,1);R(2,1) - R(1,2)];
    v = angle*r;
else
    v = [0 0 0]';
end

% End of function
end