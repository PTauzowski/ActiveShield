clear;
close all;

% Preparation of data for substation
substation = xlsread ("DATA.xlsx");
columnOfPhases=[];
for counter=2:17
  columnOfPhases=[columnOfPhases; -2*pi/3];
end
for counter=18:24
  columnOfPhases=[columnOfPhases; 0];
end
for counter=25:40
  columnOfPhases=[columnOfPhases; 2*pi/3];
end
substation=[substation, columnOfPhases];
substation(:,2)=substation(:,2)-1;
substation(:,5)=substation(:,5)-1;


% Calculation of magnetic field in observation point 
%x =0.0; y = 0.0; z = 2.+1.85; %expected values are 1.62436 and 1.08972
x =-0.10; y = 0.33; z = 2.+1.85; %expected values are 1.62436 and 1.08972
%x = 0.43; y = 0.75; z = 2.+1.85; %expected values are 1.69177 and 0.662146
%x = 0.94; y = 1.25; z = 2.+1.85; %expected values are 1.35070 and 0.266577
%x = 1.42; y = 1.74; z = 2.+1.85; %expected values are 0.920338 and 0.322471
%x = 0.18; y = 0.50; z = 2.+1.85; %expected values are 1.70098 and 0.957881
%x = 0.65; y = 1.00; z = 2.+1.85; %expected values are 1.58851 and 0.412828
%x = 1.17; y = 1.51; z = 2.+1.85; %expected values are 1.13772 and 0.275412
observation = [ x, y, z ];

% Data for initial active shield

%X=[-2 -2 3; -2  2 3;  2  2 3];
%X=[-2 -2 3; -2  2 3;  2  2 3; 2 -2 3];
%X=[-2 -2 3; -2  0 3; -2  2 3;  2  2 3; 2  0 3; 2 -2 3];
%X=[-2 -2 3; -2  0 3; -2  2 3;  0  2 3; 2  2 3; 2  0 3; 2 -2 3; 0  -2 3];

basename='pentagonal';

np=5;
X=geometryCircularInit(np);

nnodes=np;
sideShield = 4;
dist = z - X(1,3);

[Bx,By,Bz]=mf_kit( substation, [0 0 z]);
 
currentShield = abs(0.5/1.0E-7*Bz*(1/4+dist^2/sideShield^2)*sqrt(dist^2+sideShield^2/2));
phaseShield = angle(0.5/1.0E-7*Bz*(1/4+dist^2/sideShield^2)*sqrt(dist^2+sideShield^2/2));

%currentShield = 7.;
%phaseShield = 0.5*pi;
% shield = [ X1 X2 currentShield phaseShield;
%            X2 X3 currentShield phaseShield;
%            X3 X4 currentShield phaseShield;
%            X4 X1 currentShield phaseShield ];

shield = [ [X [X(2:nnodes,:); X(1,:)]] repelem(currentShield,nnodes,1) repelem(phaseShield,nnodes,1) ];
                
substationShielded = [substation; shield];

[Bx,By,Bz] = mf_kit( substation, [0 0 z]);
abs(Bz)*1.0E6
[Bx,By,Bz] = mf_kit( substationShielded, [0 0 z]);
abs(Bz)*1.0E6

lH=2.0;
uH=3.2;

X0=X';

x0 = [ X0(:)' currentShield phaseShield ];
lb = [ repmat([-2.5     -2.5     lH ],1,nnodes) 0.1            0 ];
ub = [ repmat([2.5      2.5     uH],1,nnodes)   50             2*pi];

plotRoomShieldModel(substation, x0, x0, [lb(1) lb(2) lH; ub(1) ub(2) uH]);

disp (" "); disp ("Magnetic field of substation:");
[Bx,By,Bz] = mf_kit( substation, observation);
10^6*Brms_kit( substation, observation) %return result in microT
plotMagneticField(substation,[],observation(3),50,'Magnetic field of substation'); saveas(gca, [basename '_substation.svg']);
plotMagneticField(substation,[],3.85,50,'Magnetic field of substation for observation z=3.85');

disp (" "); disp ("Mitigated magnetic field:")
[Bx,By,Bz] = mf_kit( substationShielded, observation);
10^6*Brms_kit( substationShielded, observation) %return result in microT
plotMagneticField(substation,x0,observation(3),50,{'Magnetic field' 'mitigated by initial device'}); saveas(gca, [basename '_initialy_mitigated.svg']);


of = @(x)objFn(x);
cf = @(x)cnFn(x, substation, observation,20);

%xopt = rs(of, size(x0,2), 500000, [], [], [], [], lb, ub, cf);
%xopt = ga(of, size(x0,2), [], [], [], [], lb, ub, cf);
xopt = fmincon(of,x0,[],[],[],[],lb,ub,cf);

plotShieldModel(substation, x0, xopt); view([1 0 0]); saveas(gca, [basename '_deviceYZ.svg']);
plotShieldModel(substation, x0, xopt); view([0 1 0]); saveas(gca, [basename '_deviceXZ.svg']);
plotShieldModel(substation, x0, xopt); view([0 0 1]); saveas(gca, [basename '_deviceXY.svg']);
plotShieldModel(substation, x0, xopt); view([1 1 1]); saveas(gca, [basename '_deviceXYZ.svg']);
plotMagneticField(substation,xopt,observation(3),35,{'Mitigated magnetic' 'field mitigated by optimal device'}); saveas(gca, [basename '_optimal.svg']);
of(xopt)

xopt
npoints=floor(size(xopt,2)/3);
shield = [ reshape(xopt(1:end-2),3,npoints)' reshape([xopt(4:(end-2)) xopt(1:3) ],3,npoints)' repelem(xopt(end-1),npoints,1) repelem(xopt(end),npoints,1) ];

substationShielded = [substation; shield];

[Bx,By,Bz] = mf_kit( substation, [0 0 z]);
abs(Bz)*1.0E6
[Bx,By,Bz] = mf_kit( substationShielded, [0 0 z]);
abs(Bz)*1.0E6