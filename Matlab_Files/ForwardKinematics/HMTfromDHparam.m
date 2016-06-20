function T = HMTfromDHparam(a,alphaDH,d,theta,varargin)
% GENERATE_HOMOGMATRIX_FROM_DHPARAM generates homogenous transformation matrix from Denavit-Hartenberg parameters
%
%    Author: Nasser Attar
%    Created: 2016-10-6
%    Modified: 2016-10-6
%    Change Log:

if ~isscalar(a) || ~isscalar(alphaDH) || ~isscalar(d) || ~isscalar(theta)
    error('\nInput arguments must be scalar\n')
end

T = [cos(theta),-cos(alphaDH)*sin(theta),sin(alphaDH)*sin(theta),a*cos(theta);
     sin(theta),cos(alphaDH)*cos(theta),-sin(alphaDH)*cos(theta),a*sin(theta);
     0         ,sin(alphaDH)           ,cos(alphaDH)            ,d           ;
     0         ,0                     ,0                    ,1            ];

% End of function 
end