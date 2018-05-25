function [vlist,elist] = get_straight_velist(mbdy_1,mbdy_3,b_xy)
vlist = [mbdy_1;mbdy_3;b_xy];
elist = [[1:size(mbdy_1,1)-1]';size(mbdy_1,1)+[1:size(mbdy_3,1)-1]'];
elist = [elist,elist+1];
end