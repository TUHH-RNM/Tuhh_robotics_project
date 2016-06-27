function positions = randomSpherePoints(n,x,y,z,rRange,aRange,eRange)
% RANDOMSPHEREPOSITIONS computes a set of random points in a sphere section with [x y z] as starting point
%    The elevation and azimuth ranges must be given in rad
positions = createArrays(n, [3 1]);
[aziOp,elOp,rOp] = cart2sph(x,y,z);
aziOp = aziOp*ones(n,1);
elOp = elOp*ones(n,1);
rOp = rOp*ones(n,1);
% Calculate the new elevation angles which are in eRange around elOp
elevation = elOp + eRange(1) - (eRange(1) - eRange(2))*rand(n,1);
% Calculate the new azimuth angles which are in aRange around aziOp
azimuth = aziOp + aRange(1) - (aRange(1) - aRange(2))*rand(n,1);
% Calculate the new Radii which are in rRange around rOp
radii = rOp + rRange(1) - (rRange(1) - rRange(2))*rand(n,1);
% Convert to Cartesian coordinates.
[xs,ys,zs] = sph2cart(azimuth,elevation,radii);
for i=1:n
    positions{i} = [xs(i); ys(i); zs(i)];
end

% For more information consider looking at
% http://de.mathworks.com/help/matlab/math/numbers-placed-randomly-within-volume-of-sphere.html

% End of function
end

