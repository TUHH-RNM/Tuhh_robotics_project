function [ lengths ] = ALGdistancePTP( A,B )
%ALG_PTPdistance - Measures the distance between two points A and B in 2D
%   and 3D.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   20.06.2016
%   Last modified:  20.06.2016
%   Change Log:

sum = 0;

l_A = length(A);
l_B = length(B);

if l_A ~= l_B
    error('Size of A and B musst be the same');
end

for i=1:l_A
    sum = sum + (A(i)-B(i))^2;
end
    
    
lengths = sqrt(sum);

end