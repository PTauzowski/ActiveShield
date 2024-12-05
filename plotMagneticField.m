function  plotMagneticField(substation,xopt,z,ndiv,titletext)
    ax = figure;
    x = linspace(-2.5,2.5,ndiv);
    y = linspace(-2.5,2.5,ndiv);
    [X,Y] = meshgrid(x,y);
    Z=X;
    
    if max(size(xopt))>0
         npoints=floor(size(xopt,2)/3);
         shield = [ reshape(xopt(1:end-2),3,npoints)' reshape([xopt(4:(end-2)) xopt(1:3) ],3,npoints)' repelem(xopt(end-1),npoints,1) repelem(xopt(end),npoints,1) ];
      
        substationShielded = [ substation; shield ];
    else
         substationShielded = substation; 
    end
    


    for k=1:ndiv
        for l=1:ndiv
            Z(k,l)=10^6 * Brms_kit( substationShielded, [X(k,l) Y(k,l) z] );
        end
    end
    colormap("jet");
    contour(X,Y,Z,'ShowText','on');
    title(titletext,'FontSize', 24)
    xlabel('x [m]', 'FontSize', 24, 'FontName', 'Times');
    ylabel('y [m]', 'FontSize', 24, 'FontName', 'Times');
    ax = gca;
    ax.FontSize = 24;     
    ax.FontName = 'Times'; 
end