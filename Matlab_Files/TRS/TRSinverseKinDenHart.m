function [ angles ] = TRSinverseKinDenHart( DHmatrix, DHparameters )
% TRSinverseKinDenHart - calculates the angles from the transformaton
% matrix DHmatrix according to the Denavit-Hartenberg-procedure. 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   10.06.2016
%   Last modified:  10.06.2016
%   Change Log:

%% Calculating the angles subsequently
% There are eight different sets of angles to calculate the same endpose.

%% Constants
d4 = DHparameters(4,3);
d6 = DHparameters(6,3);
a2 = DHparameters(2,1);
a3 = DHparameters(3,1);

%% theta1
angles = zeros(8,6);
p05 = DHmatrix*[0 0 -d6 1]' - [0 0 0 1]';
x05 = p05(1,1);
y05 = p05(2,1);
psi = atan2(y05,x05);
phi1 = acos(d4/sqrt(x05*x05+y05*y05));
phi2 = -acos(d4/sqrt(x05*x05+y05*y05));
theta1Pos = psi + phi1 + pi/2;
theta1Neg = psi + phi2 + pi/2;
clear p05 x05 y05 psi phi1 phi2;
angles(1:4,1) = theta1Pos;
angles(5:8,1) = theta1Neg;
 
%% theta5
p06x = DHmatrix(1,4);
p06y = DHmatrix(2,4);

p16z = p06x*sin(theta1Pos) - p06y*cos(theta1Pos); 
theta5PosPos = acos((p16z - d4)/d6);
theta5NegPos = -acos((p16z - d4)/d6);

p16z = p06x*sin(theta1Neg) - p06y*cos(theta1Neg); 
theta5PosNeg = acos((p16z - d4)/d6);
theta5NegNeg = -acos((p16z - d4)/d6);
clear p06x p06y p16z;

angles(1:2,5) = theta5PosPos;
angles(3:4,5) = theta5NegPos;
angles(5:6,5) = theta5PosNeg;
angles(7:8,5) = theta5NegNeg;

%% theta6
T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T61 = TRSinvertTransformationMatrix(T16);
zx = T61(1,3);
zy = T61(2,3);
theta6PosPos = atan2(-zy/sin(theta5PosPos),zx/sin(theta5PosPos));
theta6NegPos = atan2(-zy/sin(theta5NegPos),zx/sin(theta5NegPos));

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T61 = TRSinvertTransformationMatrix(T16);
zx = T61(1,3);
zy = T61(2,3);
theta6PosNeg = atan2(-zy/sin(theta5PosNeg),zx/sin(theta5PosNeg));
theta6NegNeg = atan2(-zy/sin(theta5NegNeg),zx/sin(theta5NegNeg));
clear T01 T01Inv T16 T61 zx zy;

angles(1:2,6) = theta6PosPos;
angles(3:4,6) = theta6NegPos;
angles(5:6,6) = theta6PosNeg;
angles(7:8,6) = theta6NegNeg;

%% theta 3
T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
theta3PosPosPos = acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
theta3NegPosPos = -acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));

T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
theta3PosNegPos = acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
theta3NegNegPos = -acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
theta3PosPosNeg = acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
theta3NegPosNeg = -acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));

T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
theta3PosNegNeg = acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
theta3NegNegNeg = -acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
clear T01 T01Inv T14 p13 T16 T45 T56;

angles(1,3) = theta3PosPosPos;
angles(2,3) = theta3NegPosPos;
angles(3,3) = theta3PosNegPos;
angles(4,3) = theta3NegNegPos;
angles(5,3) = theta3PosPosNeg;
angles(6,3) = theta3NegPosNeg;
angles(7,3) = theta3PosNegNeg;
angles(8,3) = theta3NegNegNeg;

%% theta2
T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
p13x = p13(1,1);
p13y = p13(2,1);
theta2PosPosPos = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosPosPos)/sqrt(p13'*p13));
theta2NegPosPos = -atan2(p13y,-p13x) + asin(a3*sin(theta3NegPosPos)/sqrt(p13'*p13));

T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
p13x = p13(1,1);
p13y = p13(2,1);
theta2PosNegPos = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosNegPos)/sqrt(p13'*p13));
theta2NegNegPos = -atan2(p13y,-p13x) + asin(a3*sin(theta3NegNegPos)/sqrt(p13'*p13));

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
p13x = p13(1,1);
p13y = p13(2,1);
theta2PosPosNeg = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosPosNeg)/sqrt(p13'*p13));
theta2NegPosNeg = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosPosNeg)/sqrt(p13'*p13));

T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
p13x = p13(1,1);
p13y = p13(2,1);
theta2PosNegNeg = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosNegNeg)/sqrt(p13'*p13));
theta2NegNegNeg = -atan2(p13y,-p13x) + asin(a3*sin(theta3PosNegNeg)/sqrt(p13'*p13));
clear T14 T16 T45 T56 T01 T01Inv p13 p13x p13y;

angles(1,2) = theta2PosPosPos;
angles(2,2) = theta2NegPosPos;
angles(3,2) = theta2PosNegPos;
angles(4,2) = theta2NegNegPos;
angles(5,2) = theta2PosPosNeg;
angles(6,2) = theta2NegPosNeg;
angles(7,2) = theta2PosNegNeg;
angles(8,2) = theta2NegNegNeg;

%% theta4
T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2PosPosPos);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3PosPosPos);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4PosPosPos = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2NegPosPos);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3NegPosPos);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4NegPosPos = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2PosNegPos);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3PosNegPos);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4PosNegPos = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Pos);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegPos);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegPos);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2NegNegPos);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3NegNegPos);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4NegNegPos = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2PosPosNeg);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3PosPosNeg);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4PosPosNeg = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5PosNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6PosNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2NegPosNeg);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3NegPosNeg);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4NegPosNeg = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2PosNegNeg);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3PosNegNeg);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4PosNegNeg = atan2(xy,xx);

T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1Neg);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5NegNeg);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6NegNeg);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2NegNegNeg);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3NegNegNeg);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
theta4NegNegNeg = atan2(xy,xx);

angles(1,4) = theta4PosPosPos;
angles(2,4) = theta4NegPosPos;
angles(3,4) = theta4PosNegPos;
angles(4,4) = theta4NegNegPos;
angles(5,4) = theta4PosPosNeg;
angles(6,4) = theta4NegPosNeg;
angles(7,4) = theta4PosNegNeg;
angles(8,4) = theta4NegNegNeg;

end

