function [a,alphaDH,d] = DenavitHartenbergUR5(varargin)
% DENAVITHARTENBERGUR5 outputs the Denavit-Hartenberg parameters of the UR5 robot ( of course without the joint angles )
%
%    Info: 
%    Author: Nasser Attar
%    Created: 2016-06-20
%    Modified: 2016-06-20
%    Change Log:

a = [0 -0.425 -0.39225 0 0 0]';
alphaDH = [pi/2 0 0 pi/2 -pi/2 0]';
d = [0.089159 0 0 0.10915 0.09465 0.0823]';

% End of function
end