function [coord, base] = ALGcreateCoordinates(points)
%ALGcreateCoordinages - Creates a orthonormal coordinate system out of at
%   least three points. The points have to be saved as row vectors.
%   
%   As return value the coordinates are given as two or three vectors,
%   depending on the dimension of the given points. Also the base of this
%   system is given back as a single point.
%   
%   [coord, base] = ALGcreateCoordinates(points)
%   
%   Info:
%   Designed by:    Abdul Nasser Attar; Konstantin Stepanow; Mirko Schimkat
%   Date created:   01.07.2016
%   Last modified:  02.07.2016
%   Change Log:     02.07.2016  -   Returning the base  ; Mirko Schimkat
%                               -   Error handling      ; Mirko Schimkat
%                               -   Handling 2D and 3D  ; Mirko Schimkat

%% Parameters
numberPoints = size(points,1);
numberDimm   = size(points,2);

%% Error handling
if(numberPoints < 3)
    error('Not enough points to create coordinates');
end

if((numberDimm > 3) || (numberDimm < 2)) 
    error('Dimmension not 2D or 3D');
end

%% Calculation
    diffVec21 = points(3,:) - points(1,:);
    Cx = diffVec21/ALGlenghtVec(diffVec21);
    
    diffVec31 = points(2,:) - points(1,:);
    proj = dot(Cx,diffVec31)*Cx;
    diffVec31 = diffVec31 - proj;
    Cy        = diffVec31/ALGlenghtVec(diffVec31);
    
    if numberDimm < 3
        coord = [Cx;Cy];
    else
        crossProd = cross(Cx,Cy);
        Cz = crossProd / ALGlenghtVec(crossProd);
        coord   = [Cx;Cy;Cz];
    end
    
    base    = points(1,:);
end