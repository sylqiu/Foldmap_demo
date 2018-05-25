function A = div_PtP_grad(mu,face,vertex)% this is the same with the generalized laplacian if mu<1
aaf = -(1-2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
bbf = 2*imag(mu)./(1.0-abs(mu).^2);
ggf = -(1+2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);

aaf(abs(mu)>1) = -aaf(abs(mu)>1);
bbf(abs(mu)>1) = -bbf(abs(mu)>1);
ggf(abs(mu)>1) = -ggf(abs(mu)>1);

af = aaf;
bf = bbf;
gf = ggf;
f0 = face(:,1);
f1 = face(:,2);
f2 = face(:,3);

uxv0 = vertex(f1,2) - vertex(f2,2);
uyv0 = vertex(f2,1) - vertex(f1,1);
uxv1 = vertex(f2,2) - vertex(f0,2);
uyv1 = vertex(f0,1) - vertex(f2,1); 
uxv2 = vertex(f0,2) - vertex(f1,2);
uyv2 = vertex(f1,1) - vertex(f0,1);
%lengths
l = [sqrt(sum(uxv0.^2 + uyv0.^2,2)) ...
    sqrt(sum(uxv1.^2 + uyv1.^2,2)) ...
    sqrt(sum(uxv2.^2 + uyv2.^2,2))];
%half the perimeter of each triangle, denoted s
s = sum(l,2)*0.5;
%area of triangle with sides (a,b,c) = sqrt(s(s-a)(s-b)(s-c))
area = sqrt( s.*(s-l(:,1)).*(s-l(:,2)).*(s-l(:,3)));
%
v00 = (af.*uxv0.*uxv0 + 2*bf.*uxv0.*uyv0 + gf.*uyv0.*uyv0)./area;
v11 = (af.*uxv1.*uxv1 + 2*bf.*uxv1.*uyv1 + gf.*uyv1.*uyv1)./area;
v22 = (af.*uxv2.*uxv2 + 2*bf.*uxv2.*uyv2 + gf.*uyv2.*uyv2)./area;

v01 = (af.*uxv1.*uxv0 + bf.*uxv1.*uyv0 + bf.*uxv0.*uyv1 + gf.*uyv1.*uyv0)./area;
v12 = (af.*uxv2.*uxv1 + bf.*uxv2.*uyv1 + bf.*uxv1.*uyv2 + gf.*uyv2.*uyv1)./area;
v20 = (af.*uxv0.*uxv2 + bf.*uxv0.*uyv2 + bf.*uxv2.*uyv0 + gf.*uyv0.*uyv2)./area;

I = [f0;f1;f2;f0;f1;f1;f2;f2;f0];
J = [f0;f1;f2;f1;f0;f2;f1;f0;f2];
V = [v00;v11;v22;v01;v01;v12;v12;v20;v20]./2;
%I,J are three copy of vertices, A is the matrix where the slot  
% (vertex X vertex) = (i,j) contains 
A = sparse(I,J,-V/2);

end