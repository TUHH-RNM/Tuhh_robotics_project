function [ fiducialSort ] = KINECT_identifyFiducials( refFiducials, trcFiducials )
%KINECT_identifyFiducials - Sorts the tracked fiducials (trcFiducials) in a
%   way, that they are corresponding to the points from the reference
%   systems, defined in refFiducials
%
%   Info:           
%   Designed by:    Mirko Schimkat
%   Date created:   29.06.2016
%   Last modified:  29.06.2016
%   Change Log:

%% Parameters
errorDist = 10;
minDist   = 3 ;

%% Lengthes of refFiducials and trcFiducials
% 1:    P1-P2
% 2:    P1-P3
% 3:    P1-P4
% 4:    P2-P3
% 5:    P2-P4
% 6:    P3-P4

[refDist,refPoints] = ALGdistancesBetweenFiducials(refFiducials);
[trcDist,trcPoints] = ALGdistancesBetweenFiducials(trcFiducials);

%% Sort by lengths
refSort	= sort(refDist);
trcSort = sort(trcDist);

%% Check if difference is bigger than allowed
if(max(abs(refSort - trcSort)) > errorDist)
    error('refFiducials not sufficent for trcFiducials');
end

%% Combine
ref	= [refDist     refPoints];
trc = [trcDist trcPoints];

ref	= sortrows(ref,1);
trc = sortrows(trc,1);

refDifference = diff(ref(:,1)) < minDist;
i=0;
while(~all(refDifference == 0) && (i<=length(refDifference)))
    i = i+1;
    if(refDifference(i))
        ref(i:i+1,:) = [];
        trc(i:i+1,:) = [];
        refDifference = diff(ref(:,1)) < minDist;
        i = 0;
    end
end
    
L = [ref(:,2:3) trc(:,2:3)];    

if(size(L,1) < 4)
    error('Not enough lengths remaining');
end

%% Notizen
% L1 = P1 : P2      P1 = Q3     S1 = Q1 : Q2    =  P2 : P4
% L2 = P1 : P3      P2 = Q1     S2 = Q1 : Q3    =  P2 : P1
% L3 = P1 : P4      P3 = Q4     S3 = Q1 : Q4    =  P2 : P3
% L4 = P2 : P3      P4 = Q2     S4 = Q2 : Q3    =  P4 : P1
% L5 = P2 : P4                  S5 = Q2 : Q4    =  P4 : P3
% L6 = P3 : P6                  S6 = Q3 : Q4    =  P1 : P3
%
% P1 = S3
% P2 = S4
% P3 = S2
% P4 = S1
% 

%% Identify
points = zeros(1,4);
for i=1:4
    index            = find(L(:,1:2) == i);
    index(index > 4) = index(index>4)-4;
    doppelt     = [L(index,3)' L(index,4)'];
    doppelt     = sort(doppelt);
    diffDopp    = diff(doppelt);
    index       = find(diffDopp == 0,1);
    points(i)   = doppelt(index);
end

fiducialSort = trcFiducials(points,:,:);

end

