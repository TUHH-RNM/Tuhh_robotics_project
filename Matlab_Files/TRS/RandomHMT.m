function randomTransformation = RandomHMT(anglePM, XYZtransPM)
% RandomHMT outputs a random rotation homogeneous transformation matrix
%
%   Author:  Konstantin Stepanow 
%   Date created:   14.07.2016
%   Last modified:  14.07.2016
%   Change Log: 

randomRot = randomRotations(1,-anglePM,anglePM,-anglePM,anglePM,-anglePM,anglePM);
randomRot = randomRot{1};

% Calculate random translations
xRand = XYZtransPM * (2*rand() - 1);
yRand = XYZtransPM * (2*rand() - 1);
zRand = XYZtransPM * (2*rand() - 1);

% Build the overall random transformation matrix
randomTransformation(1:3,1:3) = randomRot;
randomTransformation(1,4) = xRand/1000;
randomTransformation(2,4) = yRand/1000;
randomTransformation(3,4) = zRand/1000;
randomTransformation(4,1:4) = [0 0 0 1];

end

