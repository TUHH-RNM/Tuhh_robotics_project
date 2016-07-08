function [ points ] = DH_getRobPoints( phi,DenHat )
%DH_getRobPoints - Gives back the points of the robot joints which can be
%   used to visualize the robot in matlab or to use it for collision
%   detection and path planing. At this point, the robot is only defined by
%   the origins of the 6 coordinate system. In future there will be more
%   points to make a more precesion calculation.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   09.07.2016
%   Last modified:  09.07.2016
%   Change Log:


T1 = DH_transcTc(1,0,phi,DenHat);
T2 = T1*DH_transcTc(2,1,phi,DenHat);
T3 = T2*DH_transcTc(3,2,phi,DenHat);
T4 = T3*DH_transcTc(4,3,phi,DenHat);
T5 = T4*DH_transcTc(5,4,phi,DenHat);
T6 = T5*DH_transcTc(6,5,phi,DenHat);

p0 = [0;0;0;1];
p1 = T1 * p0;
p2 = T2 * p0;
p3 = T3 * p0;
p4 = T4 * p0;
p5 = T5 * p0;
p6 = T6 * p0;

points = [p0';p1';p2';p3';p4';p5';p6'];

end

