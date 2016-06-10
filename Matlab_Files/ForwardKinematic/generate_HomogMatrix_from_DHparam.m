function T = generate_HomogMatrix_from_DHparam(a,alpha,d,theta)
% GENERATE_HOMOGMATRIX_FROM_DHPARAM generates homogenous transformation matrix from Denavit-Hartenberg parameters
%
%    Author: Nasser Attar
%    Created: 2016-10-6
%    Modified: 2016-10-6
%    Change Log:

T = [cos(theta),-cos(alpha)*sin(theta),sin(alpha)*sin(theta),a*cos(theta);
     sin(theta),cos(alpha)*cos(theta),-sin(alpha)*cos(theta),a*sin(theta);
     0         ,sin(alpha)           ,cos(alpha)            ,d           ;
     0         ,0                     ,0                    ,1            ];

% End of function 
end