function R = HTMfromRotationVector(v,varargin)
% HTMFROMROTATIONVECTOR computes a HTM from a rotation vector
%    
%    Info: The axis of rotation is the unit vector with the same direction 
%    as v and the angle ( in rad ) is the length of v
%
%    Author: Nasser Attar
%    Created: 2016-06-20
%    Modified: 2016-06-20
%    Change Log:

if numel(v) ~= 3
    error('\nInput must have 3 elements\n')
end

R = zeros(3);
angle = sqrt(sum(v.^2));
angleCos = cos(angle);
angleSin = sin(angle);
v_unit = v/angle;

% The formulas for the 9 elements of the rotation matrix R can be found in
% the book "Robotics (Modelling, Planning, Control)" from Silicao
R(1,1) = v_unit(1)^2*(1-angleCos) + angleCos;
R(2,1) = v_unit(1)*v_unit(2)*(1-angleCos) + v_unit(3)*angleSin;
R(3,1) = v_unit(1)*v_unit(3)*(1-angleCos) - v_unit(2)*angleSin;
R(1,2) = v_unit(1)*v_unit(2)*(1-angleCos) - v_unit(3)*angleSin;
R(2,2) = v_unit(2)^2*(1-angleCos) + angleCos;
R(3,2) = v_unit(2)*v_unit(3)*(1-angleCos) + v_unit(1)*angleSin;
R(1,3) = v_unit(1)*v_unit(3)*(1-angleCos) + v_unit(2)*angleSin;
R(2,3) = v_unit(2)*v_unit(3)*(1-angleCos) - v_unit(1)*angleSin;
R(3,3) = v_unit(3)^2*(1-angleCos)+angleCos;


% End of function
end