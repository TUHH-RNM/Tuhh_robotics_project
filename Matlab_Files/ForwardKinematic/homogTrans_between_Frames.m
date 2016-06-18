function T = homogTrans_between_Frames(T_Set,src,dest)
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

if src < 0 || src > sizeT_Set(3) || dest < 0 || dest > sizeT_Set(3)
    error('\nSource or Destination are not valid\n')
end

T_dest = [eye(3),zeros(3,1);zeros(1,3),1];
if dest > 0
    T_dest = invertHTM(T_Set(:,:,dest));
end

T_src = [eye(3),zeros(3,1);zeros(1,3),1];
if src > 0
    T_src = T_Set(:,:,src);
end

T = T_dest*T_src;

% End of function
end