load('TRS\DenHartParameters.mat');

if exist('robObj')
    phi = UR5getPositionJoints(robObj);
else
    phi = [0 -45 0 0 0 0];
end

points = DH_getRobPoints(phi,DenHat);


%% Create and config figure
clf;
grid on;
hold on;
xlabel('x');
ylabel('y');
zlabel('z');
axCoords = ALGscaleAxes(points);
% axis([axCoords(1,:) axCoords(2,:) axCoords(3,:)]);
axis([-0.6 0.6 -0.6 0.6 0 1.2]);

%% Plot robot
ALGplotPTP(points(1,1:3),points(2,1:3),'k');
ALGplotPTP(points(2,1:3),points(3,1:3),'r');
ALGplotPTP(points(3,1:3),points(4,1:3),'g');
ALGplotPTP(points(4,1:3),points(5,1:3),'b');
ALGplotPTP(points(5,1:3),points(6,1:3),'m');
ALGplotPTP(points(6,1:3),points(7,1:3),'c');
ALGplotPoint(points(7,1:3),'^c');

%% Plot Head
% Center of Head
cx = -0.4;
cy      = 0;
cz      = 0.4;
radius = 0.1;

[x,y,z] = sphere;
x = x * radius;
y = y * radius;
z = z * radius;

surf(x+cx,y+cy,z+cz);

%% Detect collision
minDistArm      = radius + 0.1;
minDistJoint    = minDistArm;
ph = [cx;cy;cz];

colPhi = ~COL_limitJoints(phi);

col1 =  COL_detectCollision( points(1,1:3)',points(2,1:3)',ph,minDistArm,minDistJoint );
col2 =  COL_detectCollision( points(2,1:3)',points(3,1:3)',ph,minDistArm,minDistJoint );
col3 =  COL_detectCollision( points(3,1:3)',points(4,1:3)',ph,minDistArm,minDistJoint );
col4 =  COL_detectCollision( points(4,1:3)',points(5,1:3)',ph,minDistArm,minDistJoint );
col5 =  COL_detectCollision( points(5,1:3)',points(6,1:3)',ph,minDistArm,minDistJoint );
col6 =  COL_detectCollision( points(6,1:3)',points(7,1:3)',ph,minDistArm,minDistJoint );