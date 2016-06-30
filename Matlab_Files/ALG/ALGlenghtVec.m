function [ lengths ] = ALGlenghtVec( A )
%ALG_PTPdistance - Measures the length of Vector A and in 2D
%   and 3D.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   30.06.2016
%   Last modified:  30.06.2016
%   Change Log:

sum = 0;

l_A = length(A);
B = zeros(size(A));

for i=1:l_A
    sum = sum + (A(i)-B(i))^2;
end
    
    
lengths = sqrt(sum);

end