
function getface = get_face(bdy,face,vertex)

vx = [vertex(face(:, 1), 1), vertex(face(:, 2), 1), vertex(face(:, 3), 1)];
vy = [vertex(face(:, 1), 2), vertex(face(:, 2), 2), vertex(face(:, 3), 2)];
getface = inpolygon(mean(vx,2),mean(vy,2),bdy(:,1),bdy(:,2));
end

