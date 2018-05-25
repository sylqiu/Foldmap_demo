function [A,abc,area] = generalized_laplacian2D(v,f,mu)
% -------------------------------------------------------
% Generalized Laplacian for 2D domain
% -------------------------------------------------------
% Input : 
% 	v - vertex (3xn)
% 	f - connection (3xm)
% 	mu - Beltrami coefficient (mx1 complex)
%
% Output :
% 	A - The generalized_laplacian operator (Matrix)
% 	abc - alpha, beta and gamma representation of mu
%	area - Area of triangles in the mesh (v,f)
% -------------------------------------------------------

af = (1-2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
bf = -2*imag(mu)./(1.0-abs(mu).^2);
gf = (1+2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
abc = [af,bf,gf];

f0 = f(1,:)';
f1 = f(2,:)';
f2 = f(3,:)';

uxv0 = v(2,f1)' - v(2,f2)';
uyv0 = v(1,f2)' - v(1,f1)';
uxv1 = v(2,f2)' - v(2,f0)';
uyv1 = v(1,f0)' - v(1,f2)'; 
uxv2 = v(2,f0)' - v(2,f1)';
uyv2 = v(1,f1)' - v(1,f0)';

l = [sqrt(sum(uxv0.^2 + uyv0.^2,2)) ...
    sqrt(sum(uxv1.^2 + uyv1.^2,2)) ...
    sqrt(sum(uxv2.^2 + uyv2.^2,2))];
s = sum(l,2)*0.5;

area = sqrt( s.*(s-l(:,1)).*(s-l(:,2)).*(s-l(:,3)));

v00 = (af.*uxv0.*uxv0 + 2*bf.*uxv0.*uyv0 + gf.*uyv0.*uyv0)./area;
v11 = (af.*uxv1.*uxv1 + 2*bf.*uxv1.*uyv1 + gf.*uyv1.*uyv1)./area;
v22 = (af.*uxv2.*uxv2 + 2*bf.*uxv2.*uyv2 + gf.*uyv2.*uyv2)./area;

v01 = (af.*uxv1.*uxv0 + bf.*uxv1.*uyv0 + bf.*uxv0.*uyv1 + gf.*uyv1.*uyv0)./area;
v12 = (af.*uxv2.*uxv1 + bf.*uxv2.*uyv1 + bf.*uxv1.*uyv2 + gf.*uyv2.*uyv1)./area;
v20 = (af.*uxv0.*uxv2 + bf.*uxv0.*uyv2 + bf.*uxv2.*uyv0 + gf.*uyv0.*uyv2)./area;

I = [f0;f1;f2;f0;f1;f1;f2;f2;f0];
J = [f0;f1;f2;f1;f0;f2;f1;f0;f2];
V = [v00;v11;v22;v01;v01;v12;v12;v20;v20]/2;
A = sparse(I,J,-V);