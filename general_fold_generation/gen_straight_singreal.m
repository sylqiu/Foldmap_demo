% Generate singualr set & boudary that forms a flat-foldable twofold defined by p
% Parameters:
% mm,nn: number of points in a singular set edge
% p: 8 points specifying the siingular set, assume cw, 
% Return:
% mbdy_i: the singluar and boundary sets
% mbdy_xy: combined version
function [mbdy_1,mbdy_2,mbdy_3,mbdy_4,...
    mbdy_5,mbdy_6,mbdy_7,mbdy_8,mbdy_xy] = gen_straight_singreal(nn,mm,p)
mbdy_1 = [linspace(p(1,1),p(2,1),nn);linspace(p(1,2),p(2,2),nn)]';
mbdy_2 = [linspace(p(2,1),p(3,1),mm);linspace(p(2,2),p(3,2),mm)]';
mbdy_3 = [linspace(p(3,1),p(4,1),nn);linspace(p(3,2),p(4,2),nn)]';
mbdy_4 = [linspace(p(4,1),p(5,1),mm);linspace(p(4,2),p(5,2),mm)]';
mbdy_5 = [linspace(p(5,1),p(6,1),nn);linspace(p(5,2),p(6,2),nn)]';
mbdy_6 = [linspace(p(6,1),p(7,1),mm);linspace(p(6,2),p(7,2),mm)]';
mbdy_7 = [linspace(p(7,1),p(8,1),nn);linspace(p(7,2),p(8,2),nn)]';
mbdy_8 = [linspace(p(8,1),p(1,1),mm);linspace(p(8,2),p(1,2),mm)]';
mbdy_xy = [mbdy_1;mbdy_2(2:end,:);mbdy_3(2:end,:);mbdy_4(2:end,:);
    mbdy_5(2:end,:);mbdy_6(2:end,:);mbdy_7(2:end,:);mbdy_8(2:end,:)];
%  figure; plot(bdy(:,1),bdy(:,2),'o');axis equal;
end