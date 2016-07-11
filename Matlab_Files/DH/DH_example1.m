load('TRS\DenHartParameters.mat');
phi = UR5getPositionJoints(robObj);

points = DH_getRobPoints(phi,DenHat);

% figure
clf;
grid on;
hold on;
xlabel('x');
ylabel('y');
zlabel('z');
axCoords = ALGscaleAxes(points);

axis([axCoords(1,:) axCoords(2,:) axCoords(3,:)]);

ALGplotPTP(points(1,1:3),points(2,1:3),'k');
ALGplotPTP(points(2,1:3),points(3,1:3),'r');
ALGplotPTP(points(3,1:3),points(4,1:3),'g');
ALGplotPTP(points(4,1:3),points(5,1:3),'b');
ALGplotPTP(points(5,1:3),points(6,1:3),'m');
ALGplotPTP(points(6,1:3),points(7,1:3),'c');
ALGplotPoint(points(7,1:3),'^c');
