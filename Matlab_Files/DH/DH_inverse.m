function [ Tout ] = DH_inverse( Tin )
%DH_inverse - Creates the inverse of DH_transcTc
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   09.07.2016
%   Last modified:  09.07.2016
%   Change Log:

if size(Tin,1) ~= 4 || size(Tin,2) ~= 4
    error('Wrong dimension');
end

R = Tin(1:3,1:3);
t = Tin(1:3,4);

Tout       = [R';[0 0 0]];
Tout(1:4,4)= -R'*t;

end

