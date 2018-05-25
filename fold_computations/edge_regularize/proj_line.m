function v = proj_line(sing_index, vertex)
pts = vertex(sing_index,:);
p1 = pts(1,:); pn = pts(end,:);
u = pn - p1;
u = u/norm(u);
u = repmat(u,size(pts,1),1);
v = repmat(sum((pts-repmat(p1,size(pts,1),1)).*u,2),1,2).*u + repmat(p1,size(pts,1),1);
end