function [X] = geometryCircularInit(np)
    dphi=2*pi/np;
    phi0=pi/5;
    X=[];
    for k=1:np
        X=[X; [ 2*sin(phi0+k*dphi) 2*cos(phi0+k*dphi) 3] ];
    end
end

