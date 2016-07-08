function [ out ] = ALGscaleAxes( points )
%ALGscaleAxes - gives back the vector to scale in a 3D plot the axas in a
%   way, that all points are inside the plot and the axes have the same
%   proportion.
%
%   Info:
%   Designed by:    Mirko Schimkat
%   Date created:   09.07.2016
%   Last modified:  09.07.2016
%   Change Log:


x_min = min(points(:,1));
x_max = max(points(:,1));
y_min = min(points(:,2));
y_max = max(points(:,2));
z_min = min(points(:,3));
z_max = max(points(:,3));

lx  =   x_max-x_min;
ly  =   y_max-y_min;
lz  =   z_max-z_min;

mx  =   x_min + lx/2;
my  =   y_min + ly/2;
mz  =   z_min + lz/2;

lh = max([lx;ly;lz])/2;

xs_min = mx-lh;
xs_max = mx+lh;
ys_min = my-lh;
ys_max = my+lh;
zs_min = mz-lh;
zs_max = mz+lh;
 
out = [xs_min xs_max ys_min ys_max zs_min zs_max];

end

