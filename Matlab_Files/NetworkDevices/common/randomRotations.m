function T = randomRotations(n, rollMin, rollMax, pitchMin, pitchMax, yawMin, yawMax)
% RANDOMROTATION outputs a random rotation matrix T within a specified range of RPY-angles
%
%   Author:  Unknown
%   Date created:   Unknown
%   Last modified:  27.06.16
%   Change Log: 

T = createArrays(n, [3,3]);

phi = (rollMin-rollMax)*rand(n,1) + rollMax;
theta = (pitchMin-pitchMax)*rand(n,1) + pitchMax;
psi = (yawMin-yawMax)*rand(n,1) + yawMax;

for i=1:n
    Rzphi = [cosd(phi(i)) -sind(phi(i)) 0 ;
             sind(phi(i))  cosd(phi(i)) 0 ;
                0              0        1];
            
    Rytheta = [ cosd(theta(i))  0  sind(theta(i)) ;
                    0           1         0       ;
               -sind(theta(i))  0  cosd(theta(i))];
           
    Rxpsi = [1      0              0      ;
             0 cosd(psi(i)) -sind(psi(i)) ;
             0 sind(psi(i))  cosd(psi(i))];
    
    T{i} = Rzphi * Rytheta * Rxpsi;
end

% End of function
end

