function [c,ceq]  = cnFn(x, substation, observation,ndiv)
    
    ceq=[];
    npoints=floor(size(x,2)/3);

    shield = [ reshape(x(1:end-2),3,npoints)' reshape([x(4:(end-2)) x(1:3) ],3,npoints)' repelem(x(end-1),npoints,1) repelem(x(end),npoints,1) ];
                
    substationShielded = [ substation; shield ];

    x0=[0 0 2.5];
    lb=[-2.5 -2.5 2.0];
    ub=[ 2.5  2.5 3.2];
 %    of = @(x)(-10^6 * Brms_kit( substationShielded, x ));
 %    [xm, val] = fmincon(of,x0,[],[],[],[],lb,ub);
    
    x = linspace(-2.5,2.5,ndiv);
    y = linspace(-2.5,2.5,ndiv);
    [X,Y] = meshgrid(x,y);
    Z=X;
    zp = observation(3);
    for k=1:ndiv
        for l=1:ndiv
            Z(k,l)=10^6 * Brms_kit( substationShielded, [X(k,l) Y(k,l) zp] );
        end
    end
   [val,M]=max(Z(:));
    c = val-0.5;
end

