function T_Set = generate_BaseToRefFrameHMT_from_DHparam(a,alphaDH,d,theta)
% GENERATE_BASETOREFFRAMEHMT_FROM_DHPARAM generates set of HTMs from DH-parameters
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

if (numel(a) ~= numel(alphaDH)) || (numel(d) ~= numel(theta)) || (numel(a) ~= numel(d))
    error('\nNumber of DH-parameters is not consistent\n')
end

nDHparam = numel(a);
T_Set = zeros(4,4,nDHparam);
T = eye(4);
for i = 1:nDHparam
    T = T*generate_HomogMatrix_from_DHparam(a(i),alphaDH(i),d(i),theta(i));
    T_Set(:,:,i) = T;
end
% End of function
end