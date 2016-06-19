function [ out ] = TRSatan2(a, b)
% TRSatan2Modified - converts the inputs a and b into the respective 
% angle according to the lecture
%
%
%   Info:
%   Designed by:    Konstantin Stepanow
%   Date created:   12.06.2016
%   Last modified:  12.06.2016
%   Change Log:

if (b > 0)       
    if (a < 0)
        out = atan(a/b) + 2*pi;
    elseif (a >= 0)
        out = atan(a/b);
    end    
%------------------%  
elseif (b == 0)
    if (a > 0)
        out = pi/2;
    elseif (a == 0)
        out = 0;
    elseif (a < 0)
        out = 3*pi/2;
    end
%------------------%
elseif (b < 0)
    if (a >= 0)
        out = atan(a/b) + pi;
    elseif (a < 0)
        out = atan(a/b) + pi; 
    end
end  

end

