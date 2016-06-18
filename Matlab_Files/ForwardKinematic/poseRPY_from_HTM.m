function poseRPY = poseRPY_from_HTM(T)
% POSERPY_FROM_HTM computes the position and orientation in RPY from HMT
%
%    Author: Nasser Attar
%    Created: 2016-06-10
%    Modified: 2016-06-10
%    Change Log:

if ~isequal(size(T),[4 4])
    error('\nDimensions of HTM are not correct\n')
end

pos = T(1:3,4);
R = T(1:3,1:3);

if R(1,1) > 0 || R(2,1) > 0
    y1 = atan2(R(2,1),R(1,1));
    p1 = atan2(-R(3,1),sqrt(R(3,2)^2+R(3,3)^2));
    r1 = atan2(R(3,2),R(3,3));
    
    y2 = atan2(-R(2,1),-R(1,1));
    p2 = atan2(-R(3,1),-sqrt(R(3,2)^2+R(3,3)^2));
    r2 = atan2(-R(3,2),-R(3,3));
    
    poseRPY = [pos,pos;[r1 p1 y1]',[r2 p2 y2]'];
else
    % Only the difference of y1 and r1 is computable (y1 - r1)
    if R(3,1) < 0
        r = atan2(R(1,2),R(2,2));
        p = pi/2;
        y = NaN;
    else
        r = atan2(-R(1,2),R(2,2));
        p = 3*pi/2;
        y = NaN;
    end
    poseRPY = [pos;[r p y]'];
end

% End of function
end