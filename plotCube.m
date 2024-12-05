function plotCube(x1,y1,z1,dx,dy,dz,color,lwidth)
    x2=x1+dx;
    y2=y1+dy;
    z2=z1+dz;
    coord = [...
        x1    y1    z1;
        x2  y1    z1;
        x2  y2  z1;
        x1    y2  z1;
        x1    y1    z2;
        x2  y1    z2;
        x2  y2  z2;
        x1   y2  z2;];
    idx = [4 8 5 1 4; 1 5 6 2 1; 2 6 7 3 2; 3 7 8 4 3; 5 8 7 6 5; 1 4 3 2 1]';
    patch('vertices', coord, 'faces', idx', 'edgecolor', color, 'facealpha', 0.0, 'LineWidth', lwidth);
end

