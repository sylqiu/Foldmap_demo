function texture_image = texture_map(face,vertex,new_vertex,imagefilename)
im = imread(imagefilename);
zcoord = (vertex(:,1)+vertex(:,2))*0.2;
new_vertex_3d = [new_vertex,zcoord];
texturecoor = [1-vertex(:,2)/sy,1-vertex(:,1)/sx];
patchtop(face,new_vertex_3d,face,texturecoor,im,128,1.5);
shading flat; 
axis off; axis equal
saveas(gcf,'test_texture.png');
texture_image = imread('test_straight.png');
end