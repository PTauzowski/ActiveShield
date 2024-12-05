%Calculation of magnetic field created by kit of segments
% Variable "kit" is array with following type of elements:
% [three coordinates of start point of segment, three coordinates of end,
% RMS of current, its initial phase]
% observation(x,y,z) is the observation point
% Bx,By,Bz are the components of magnetic flux density in the observation point

function [Bx, By, Bz] = mf_kit( kit, observation )

    Bx=0; By=0; Bz=0;
    
    for counter=1:size(kit,1)
       point1 = [ kit(counter,1), kit(counter,2), kit(counter,3)];
       point2 = [ kit(counter,4), kit(counter,5), kit(counter,6)];
       [Bx_segment, By_segment, Bz_segment] = ...
          mf_segment( point1, point2, kit(counter,7)*exp(1i*kit(counter,8)), observation);
      Bx = Bx+Bx_segment;
      By = By+By_segment;
      Bz = Bz+Bz_segment;
    end

end