function [ matrix ] = ALGrotateMatrix( order, degree )
%ALFrotateMatrix - Creates a rotation matrix
%   The function creates a matrix, which contains rotations about the 3
%   axes of a system. The rotation degrees are given to the function in a
%   vector and the order in which the roations should be performed are
%   given as a string with the x,y and z by the parameter "order"
%
%   Eg.:
%   mat = ALGrotateMatrix('xzxy',[10 90 -4 3]);
%   mat contains a rotation matrix which rotates a vector first for 10
%   degree positiv around x, then for 90 degree around the z axes, then
%   again for -4 degree around the x axes and then for 3 degree around y.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   06.06.2016
%   Last modified:  06.06.2016
%   Change Log:

%% Error handling
if length(order) ~= length(degree)
    error('Length of "order" and "degree" must be the same size');
end
         
%% Multiply matrizes
matrix = eye(3);

for i=1:length(order)
    if(strcmp(order(i),'x'))
        matrix = ALGrotateX(degree(i)) * matrix;
    elseif(strcmp(order(i),'y'))
        matrix = ALGrotateY(degree(i)) * matrix;
    elseif(strcmp(order(i),'z'))
        matrix = ALGrotateZ(degree(i)) * matrix;
    end
end