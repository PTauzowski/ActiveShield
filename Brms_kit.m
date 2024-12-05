% Calculation of RMS value of magnetic flux density B,
% when magnetic field is created by kit of segments
% Variable "kit" is array with following type of elements:
% [three coordinates of start point of segment, three coordinates of end,
% RMS of current, its initial phase]
% observation(x,y,z) is the observation point
% Bx,By,Bz are the components of magnetic flux density in the observation point

function B = Brms_kit( kit, observation)

[Bx,By,Bz] = mf_kit( kit, observation);
B = norm( [Bx,By,Bz]);
%B = sqrt( abs(Bx)^2 + abs(By)^2 + abs(Bz)^2);

end