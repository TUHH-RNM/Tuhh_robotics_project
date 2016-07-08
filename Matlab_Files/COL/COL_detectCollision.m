function [ collision ] = COL_detectCollision( p1,p2,ph,minDistArm,minDistJoint )
%COL_detectCollision - Checks if the distance between the point ph and the
%   arm, defined by the two points p1 and p2 which are in the joints of
%   each end of the arm is smaller than minDistArm, if the point is between
%   the two joints or smaller than minDistJoint if the point is outside
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   09.07.2016
%   Last modified:  09.07.2016
%   Change Log:

L  = p2-p1;
L  = L./norm(L);

s1 = ph-p1;
s2 = ph-p2;
n1 = norm(s1);
n2 = norm(s2);
s1norm = s1./n1;
s2norm = s2./n2;

angle  = acosd(dot(s1norm,s2norm));

if (angle <= 90)
    if(min([n1;n2]) < minDistJoint)
        collision = true;
    else 
        collision = false;
    end
else
    p = dot(s1,L) * L;
    d = s1-p;
    if norm(d) < minDistArm
        collision = true;
    else
        false
    end    
end
end

