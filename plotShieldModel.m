function  plotShieldModel(substation, x0, x)
  ax = figure;
  daspect([1 1 1]);
  for k=1:size( substation, 1)
      line([substation(k,1); substation(k,4)], [substation(k,2); substation(k,5)], [substation(k,3); substation(k,6)],'Color','blue','LineWidth',2);
  end

  xpts0 = reshape(x0(1:end-2),3,floor(size(x,2)/3))';
  xpts = reshape(x(1:end-2),3,floor(size(x,2)/3))';
  
  line([xpts0(:,1); xpts0(1,1)],[xpts0(:,2); xpts0(1,2)],[xpts0(:,3); xpts0(1,3)],'Color','red');
  line([xpts(:,1); xpts(1,1)],[xpts(:,2); xpts(1,2)],[xpts(:,3); xpts(1,3)],'Color','magenta','LineWidth',3);
    xlabel('x [m]', 'FontSize', 24, 'FontName', 'Times');
    ylabel('y [m]', 'FontSize', 24, 'FontName', 'Times');
    zlabel('z [m]', 'FontSize', 24, 'FontName', 'Times');
    ax = gca;
    ax.FontSize = 24;     
    ax.FontName = 'Times'; 
end

