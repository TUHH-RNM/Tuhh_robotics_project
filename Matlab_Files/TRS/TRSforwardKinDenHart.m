function [ matricesOut ] = TRSforwardKinDenHart( angles, DenHartParameters, matrices)
% TRSforward - calculates the transformation matrix from the 
% Denavit-Hartenberg-parameters and the given angles. The variable
% matrices contains the numbers of the desired transformation matrices.
% 
% Example: matrices = 1 gives you the respective matrix: T01
% matrices = [1 2] gives you the respective matrices: T01 and T12 
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   02.06.2016
%   Last modified:  10.06.2016
%   Change Log:

%% Consistency check
% Check if Den.-Hart.-table dimensions match the angle dimensions 
if numel(angles) == numel(DenHartParameters(:,1)) && ...
   numel(angles) == numel(DenHartParameters(:,2)) && ... 
   numel(angles) == numel(DenHartParameters(:,3)) && ...
   numel(angles) >= numel(matrices);
else
    msg = 'Den.-Hart.-parameters and angles dimensions mismatch!';
    error(msg);
end

%% Assigning the incoming parameters 
% Denavit-Hartenberg-parameters   
a =     DenHartParameters(:,1); % vector of all as   
alpha = DenHartParameters(:,2); % vector of all alphas
d =     DenHartParameters(:,3); % vector of all ds  

% sines / cosines of the angles
s =     sind(angles);           % vector of all sines of thetas
c =     cosd(angles);           % vector of all cosines of thetas
ca =    cosd(alpha);            % vector of all sines of alphas
sa =    sind(alpha);            % vector of all cosine of alphas

% calculating the desired matrices according to the given 
% vector (matrices)
numberOfMatrices = length(matrices);
matricesOut = zeros(4,4,numberOfMatrices); % prelocating memory
for k=1:numberOfMatrices
    i = matrices(k); %  i is the number of the k-th matrix
    matricesOut(:,:,k) = ... 
        [c(i)   -ca(i)*s(i)     sa(i)*s(i)          a(i)*c(i);
         s(i)   ca(i)*c(i)      -sa(i)*c(i)         a(i)*s(i);
         0      sa(i)           ca(i)               d(i);
         0      0               0                   1];  
end

end

