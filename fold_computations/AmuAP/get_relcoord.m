function [X,Y] = get_relcoord(v)
L = size(v, 1); %length(v(:,1));

v0 = [0,0];
v1 = [1,0];
X = zeros(L,3);
Y = zeros(L,3);
for i = 1:L
  [X(i, :),Y(i, :)] = relative_coordinates([v0;v1;v(i, :)],[1,2,3]);
end
end
