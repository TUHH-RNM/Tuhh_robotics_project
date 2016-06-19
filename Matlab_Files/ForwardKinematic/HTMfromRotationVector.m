function T = HTMfromRotationVector(v)
% HTMFROMROTATIONVECTOR computes a HTM from a rotation vector
%    
%    Info: The axis of rotation is the unit vector with the same direction 
%    as v and the angle ( in rad ) is the length of v
%    Author: Nasser Attar
%    Created: 2016-06-20
%    Modified: 2016-06-20
%    Change Log:

if numel(v) ~= 3
    error('\nInput must have 3 elements\n')
elseif size(v,1) < size(v,2)
    v = v';
end

angle = sqrt(sum(v.^2));
v_unit = v/angle;
vXY = [v_unit(1:2);0];
vZX = [v_unit(1);0;v_unit(3)];
% Compute the angles of the rotation vector 
aZ = [1 0 0]*vXY*sign(cross([1 0 0]',vXY)*[0 0 1]');
aY = [0 0 1]*vZX*sign(cross([0 0 1]',vZX)*[0 1 0]');
ForwardRotation = ZRotationMatrix(aZ)*YRotationMatrix(aY);
BackwardRotation = YRotationMatrix(-aY)*ZRotationMatrix(-aZ);
T = ForwardRotation*ZRotationMatrix(angle)*BackwardRotation;

% End of function
end