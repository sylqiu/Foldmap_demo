% cotw is size(edge,1) by 1, cotagent weight of each edge
function wij = cotweight(vertex,face,edge,ef)
cot = cotangent(vertex,face); %in face f, cot of [v1,v2,v3]
alpha = zeros(size(edge, 1), 2);
% ov = zeros(size(edge, 1), 2);
for edge_i = 1:size(edge,1)
   face_ind = ef(edge_i,:);
   for k = 1 : 2
       if face_ind(k) < 0
           alpha(edge_i, k) = 0;
%            ov(edge_i, k) = -1; %
           continue;
       end
       for j = 1 : 3
           vts = face(face_ind(k), :);
           
           if vts(j) ~= edge(edge_i, 1) && vts(j) ~= edge(edge_i, 2)
               alpha(edge_i, k) = cot(face_ind(k), j);
%                ov(edge_i, k) = vts(j);
           end
       end
   end
end
wij = sum(alpha, 2);
end




