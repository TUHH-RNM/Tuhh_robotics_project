angle = 90;
axis  = [2 0 0];

axis = axis / ALGlenghtVec(axis);

c = cosd(angle);
s = sind(angle);
t = 1 - c;
x = axis(1);
y = axis(2);
z = axis(3);

R(1,:) = [(t*x*x + c)   (t*x*y - z*s) (t*x*z + y*s)];
R(2,:) = [(t*x*y + z*s)	(t*y*y + c)	  (t*y*z - x*s)];
R(3,:) = [(t*x*z - y*s)	(t*y*z + x*s) (t*z*z + c)  ];