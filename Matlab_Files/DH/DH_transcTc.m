function [ T ] = DH_transcTc( from, to, phi, denHat )
%DH_transcTc - Calculates the transformatrix between two neighboaring
%   coordinate systems of the UR5. from has to be one number higher than to
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   09.07.2016
%   Last modified:  09.07.2016
%   Change Log:

if from == to
    T = eye(4);
    warning('From and to are the same');
elseif(from == to+1)
            Tz      = eye(4);
    Tz(3,4) = denHat.d(from);
    Rz      = [cosd(phi(from)) -sind(phi(from))  0  0;
               sind(phi(from))  cosd(phi(from))  0  0;
               0  0  1  0;
               0  0  0  1];
           
    Tx      = eye(4);
    Tx(1,4) = denHat.a(from);
    Rx      = [1 0 0 0;
               0 cosd(denHat.alpha(from)) -sind(denHat.alpha(from)) 0;
               0 sind(denHat.alpha(from))  cosd(denHat.alpha(from)) 0;
               0 0 0 1];
    T = Tz*Rz*Tx*Rx;
else
    error('from must be exactly = to +1');
end

end