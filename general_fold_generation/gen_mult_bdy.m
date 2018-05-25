function bdy_xy = gen_mult_bdy(bdy_p,sx,sy)
A = [0,0;sx-1,0;sx-1,sy-1;0,sy-1];
temp = [linspace(bdy_p(1,1),bdy_p(1+1,1),bdy_p(1,3));...
        linspace(bdy_p(1,2),bdy_p(1+1,2),bdy_p(1,3))]';
bdy_xy = temp(1:end-1,:);
for i = 2:size(bdy_p,1)-1
    temp = [linspace(bdy_p(i,1),bdy_p(i+1,1),bdy_p(i,3));...
        linspace(bdy_p(i,2),bdy_p(i+1,2),bdy_p(i,3))]';
    if ismember(bdy_p(i,1:2),A,'rows')
        bdy_xy = [bdy_xy; temp(1:end-1,:)];
    else
        bdy_xy = [bdy_xy; temp(2:end-1,:)];
    end
end
% bdy_xy = bdy_xy(1:end-1,:);
end