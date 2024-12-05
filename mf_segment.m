% Calculation of magnetic field created by segment carrying current
% point1(x1,y1,z1) and point2(x2,y2,z2) are the end points of segment
% Current flows from point1 to point2
% phasorCurrent is the phasor of current divided by sqrt(2),
% so abs(phasorCurrent) is equal to RMS of current
% observation(x,y,z) is the observation point
% Bx,By,Bz are the components of magnetic flux density in the observation point

function [Bx, By, Bz] = mf_segment( point1, point2, phasorCurrent, observation)

x1 = point1(1); y1 = point1(2); z1 = point1(3);
x2 = point2(1); y2 = point2(2); z2 = point2(3);
x = observation(1); y = observation(2); z = observation(3);

% Vacuum permeability divided by 4*pi
mu=10^-7;

% Auxiliary variables
ax=x2-x1;
ay=y2-y1;
az=z2-z1;
A1=[ay az
    y1-y z1-z];
A2=[az ax
    z1-z x1-x];
A3=[ax ay
    x1-x y1-y];

% Distance from point P to segment P1P2 
h=sqrt((det(A1)^2+det(A2)^2+det(A3)^2)/(ax^2+ay^2+az^2));

% Cosine of angle between vectors Ð1-Ð and Ð1-Ð2
cosPhi1=((x2-x1)*(x-x1)+(y2-y1)*(y-y1)+(z2-z1)*(z-z1))/sqrt(((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)*((x-x1)^2+(y-y1)^2+(z-z1)^2));

% Cosine of angle between vectors Ð2-Ð and Ð2-Ð1
cosPhi2=((x1-x2)*(x-x2)+(y1-y2)*(y-y2)+(z1-z2)*(z-z2))/sqrt(((x2-x1)^2+(y2-y1)^2+(z2-z1)^2)*((x-x2)^2+(y-y2)^2+(z-z2)^2));

% Magnetic flux density in point P
B=mu*phasorCurrent*(cosPhi1+cosPhi2)/h;

% Direction of vector of magnetic flux density
vx=(y1-y)*(z2-z)-(y2-y)*(z1-z);
vy=(x2-x)*(z1-z)-(x1-x)*(z2-z);
vz=(x1-x)*(y2-y)-(x2-x)*(y1-y);
v=sqrt(vx^2+vy^2+vz^2);

% Components of vector of magnetic flux density
Bx=B*vx/v;
By=B*vy/v;
Bz=B*vz/v;

end