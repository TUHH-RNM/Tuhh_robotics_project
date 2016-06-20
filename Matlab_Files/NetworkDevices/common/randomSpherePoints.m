function positions = randomSpherePoints(n,r,x,y,z)
%RANDOMSPHEREPOSITIONS Summary of this function goes here
%   Detailed explanation goes here

% http://de.mathworks.com/help/matlab/math/numbers-placed-randomly-within-volume-of-sphere.html
positions = createArrays(n, [3 1]);
% Calculate an elevation angle for each point in the sphere. These values are in the open interval,
% (-pi/2,pi/2), but are not uniformly distributed.
rvals = 2*rand(n,1)-1;
elevation = asin(rvals);
% Create an azimuth angle for each point in the sphere.
% These values are uniformly distributed in the open interval,  (0,2pi).
azimuth = 2*pi*rand(n,1);
% Create a radius value for each point in the sphere. These values are in the open interval,
% (0,3), but are not uniformly distributed.
radii = r*(rand(n,1).^(1/3));
% Convert to Cartesian coordinates.
[xs,ys,zs] = sph2cart(azimuth,elevation,radii);
% Moving the center.
xs = xs+x; ys = ys+y; zs = zs+z;
for i=1:n
    positions{i} = [xs(i); ys(i); zs(i)];
end
end

