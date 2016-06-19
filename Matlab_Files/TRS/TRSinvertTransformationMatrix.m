function [ matrixOut ] = TRSinvertTransformationMatrix( matrixIn )
% TRSinvertTransformationMatrix -
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   02.06.2016
%   Last modified:  10.06.2016
%   Change Log:

R = matrixIn(1:3,1:3);
t = matrixIn(1:3,4);

matrixOut = [R', -R'*t; 0 0 0 1];

end

