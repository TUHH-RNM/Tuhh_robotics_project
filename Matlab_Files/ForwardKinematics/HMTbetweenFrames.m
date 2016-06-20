function T = HMTbetweenFrames(T_Set,from,to,varargin)
% HOMOGTRANS_BETWEEN_FRAMES computes the transformation between two arbitrary frames represented by the 3D-array T_Set
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

sizeT_Set = size(T_Set);

if (ndims(T_Set) ~= 3) || (~isequal(sizeT_Set(1:2),[4 4]))
    error('\nDimensions of input matrix are not correct\n')
end

if from < 0 || from > sizeT_Set(3) || to < 0 || to > sizeT_Set(3)
    error('\nSource or Destination are not valid\n')
end

T_dest = [eye(3),zeros(3,1);zeros(1,3),1];
if to > 0
    T_dest = invertHTM(T_Set(:,:,to));
end

T_src = [eye(3),zeros(3,1);zeros(1,3),1];
if from > 0
    T_src = T_Set(:,:,from);
end

T = T_dest*T_src;

% End of function
end