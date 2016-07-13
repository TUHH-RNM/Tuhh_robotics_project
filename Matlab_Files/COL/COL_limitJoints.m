function [ colFree ] = COL_limitJoints( phi, varargin )
%COL_LIMITJOINTS Summary of this function goes here
%   Detailed explanation goes here

colFree = zeros(1,6);

%% Joint 1 (No restriction)
colFree(1) = true;

%% Joint 2
if (-170 < phi(2)) && (phi(2) < -10)
    colFree(2) = true;
else
    colFree(2) = false;
end

%% Joint 3
if (-145 < phi(3)) && (phi(3) < 145)
    colFree(3) = true;
else
    colFree(3) = false;
end

%% Joint 4 (No restriction)
colFree(4) = true;

%% Joint 5 (No restriction)
colFree(5) = true;

%% Joint 6 (No restriction)
colFree(6) = true;

end

