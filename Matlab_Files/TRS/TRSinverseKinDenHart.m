function [ angles ] = TRSinverseKinDenHart( DHmatrix, DHparameters, config)
% TRSinverseKinDenHart - calculates the angles from the transformaton
% matrix DHmatrix according to the Denavit-Hartenberg-procedure. The 
% output are the corresponding angles to the given configuration. 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   11.07.2016
%   Last modified:  11.07.2016
%   Change Log:

configSplit = strsplit(config);
angles = [NaN NaN NaN NaN NaN NaN];

%% Calculating the angles subsequently
% There are eight different sets of angles to calculate the same endpose.

%% Constants
d4 = DHparameters(4,3);
d6 = DHparameters(6,3);
a2 = DHparameters(2,1);
a3 = DHparameters(3,1);

%% theta1
p05 = DHmatrix*[0 0 -d6 1]' - [0 0 0 1]';
x05 = p05(1,1);
y05 = p05(2,1);
if isreal(x05) && isreal(y05) 
    psi = atan2(y05,x05);
else
    psi = NaN;
end
phi1 = acos(d4/sqrt(x05*x05+y05*y05));
phi2 = -phi1;
theta1Pos = psi + phi1 + pi/2;
theta1Neg = psi + phi2 + pi/2;

if strcmp(configSplit(3),'righty');
    angles(1) = theta1Pos;   
elseif strcmp(configSplit(3),'lefty');
    angles(1) = theta1Neg;    
else
    msgbox('Inverse kinematics: configuration string is invalid', 'Error','error');
end
 
%% theta5
p06x = DHmatrix(1,4);
p06y = DHmatrix(2,4);
theta1 = angles(1);
p16z = p06x*sin(theta1) - p06y*cos(theta1); 
theta5Pos = acos((p16z - d4)/d6);
theta5Neg = -theta5Pos;

if strcmp(configSplit(1),'flip');
    angles(5) = theta5Pos;   
elseif strcmp(configSplit(1),'noflip');
    angles(5) = theta5Neg;    
else
    msgbox('Inverse kinematics: configuration string is invalid', 'Error','error');
end

%% theta6
theta1 = angles(1);
theta5 = angles(5);
T01 = TRSforwardKinDenHart(DHparameters(1,:), theta1);
T01Inv = TRSinvertTransformationMatrix(T01);
T16 = T01Inv*DHmatrix;
T61 = TRSinvertTransformationMatrix(T16);
zx = T61(1,3);
zy = T61(2,3);
if isreal(zx) && isreal(zy) 
    theta6 = atan2(-zy/sin(theta5), zx/sin(theta5));
else
    theta6 = NaN;
end
angles(6) = theta6;

%% theta 3
theta5 = angles(5);
theta6 = angles(6);
T45 = TRSforwardKinDenHart(DHparameters(5,:), theta5);
T56 = TRSforwardKinDenHart(DHparameters(6,:), theta6);
T14 = T16*TRSinvertTransformationMatrix(T45*T56);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
theta3Pos = acos((p13'*p13-a2*a2-a3*a3)/(2*a2*a3));
theta3Neg = -theta3Pos;

if strcmp(configSplit(2),'up');
    angles(3) = theta3Pos;   
elseif strcmp(configSplit(2),'down');
    angles(3) = theta3Neg;    
else
    msgbox('Inverse kinematics: configuration string is invalid', 'Error','error');
end

%% theta2
theta3 = angles(3);
p13 = T14*[0 -d4 0 1]' - [0 0 0 1]';
p13x = p13(1,1);
p13y = p13(2,1);
if isreal(p13x) && isreal(p13y) 
    theta2 = -atan2(p13y,-p13x) + asin(a3*sin(theta3)/sqrt(p13'*p13));
else
    theta2 = NaN;
end
angles(2) = theta2;

%% theta4
theta2 = angles(2);
T12 = TRSforwardKinDenHart(DHparameters(2,:), theta2);
T23 = TRSforwardKinDenHart(DHparameters(3,:), theta3);
T31 = TRSinvertTransformationMatrix(T12*T23);
T34 = T31*T14;
xx = T34(1,1);
xy = T34(2,1); 
if isreal(xx) && isreal(xy) 
    theta4 = atan2(xy,xx);
else
    theta4 = NaN;
end
angles(4) = theta4;

%%
angles = round(angles*360/(2*pi),2);

if isreal(angles)
else
    angles = [NaN NaN NaN NaN NaN NaN];
end

end

