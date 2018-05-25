function plot_facemu(face,vertex,mu)
% mu_big = mubig(mu);

patch('Faces',face,'Vertices',vertex,'FaceVertexCData',mu,'FaceColor','flat', 'FaceAlpha',0.5); 
% colorbar;caxis([0,10]);
end