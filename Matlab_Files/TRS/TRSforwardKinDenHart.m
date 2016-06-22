function [ matrixOut ] = TRSforwardKinDenHart( DenHartParameters, angles)
% TRSforward - calculates the transformation matrix from the 
% Denavit-Hartenberg-parameters and the given angle. 
%
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   02.06.2016
%   Last modified:  10.06.2016
%   Change Log:

%% Consistency check
% Check if Den.-Hart.-table dimensions match the angle dimensions 
if numel(angles)*3 > numel(DenHartParameters)
    msg = 'Too many angles or not enough Den.-Hart.-parameters!';
    error(msg);    
end

%% Assigning the incoming parameters  
a =     DenHartParameters(:,1); % vector of all as   
alpha = DenHartParameters(:,2); % vector of all alphas
d =     DenHartParameters(:,3); % vector of all ds 

%% Assigning the variable angle
theta = angles;

matrixOut = eye(4,4);
for i=1:numel(theta)
%% Calculating the matrix
matrixOut = matrixOut * ... 
[cosd(theta(i))  -cosd(alpha(i))*sind(theta(i))    sind(alpha(i))*sind(theta(i))     a(i)*cosd(theta(i));
 sind(theta(i))  cosd(alpha(i))*cosd(theta(i))     -sind(alpha(i))*cosd(theta(i))    a(i)*sind(theta(i));
 0               sind(alpha(i))                   cosd(alpha(i))                   d(i);
 0               0                                0                                1];
end

end

