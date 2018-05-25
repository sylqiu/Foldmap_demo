%% generalized laplacian
% Discretize generalized laplacian operator as a sparse matrix.
%  
% Generalized laplacian operator has the form 
% 
% \[ \nabla (D \cdot \nabla) \]
% 
% where \( D = [a,b;b,c] \) and \( \mu = \rho + \imath \tau \)
% 
% \( a = \frac{(1-\rho)^2+\tau^2}{1-\rho^2-\tau^2} \),
% \( b = \frac{ -2\tau}{1-\rho^2-\tau^2} \),
% \( c = \frac{(1+\rho)^2+\tau^2}{1-\rho^2-\tau^2} \).
% 
% More details on discretization, pleas refer to [1].
% 
% # Lui, L., Lam, K., Yau, S., and Gu, X. Teichmuller Mapping (T-Map) and Its
% Applications to Landmark Matching Registration. SIAM Journal on Imaging 
% Sciences 2014 7:1, 391-426
%
%% Syntax
%   A = generalized_laplacian(face,uv,mu)
%
%% Description
%  face: double array, nf x 3, connectivity of mesh
%  uv  : double array, nv x 2, uv coordinate of mesh
%  mu  : complex array, nf x 1, beltrami coefficient on all faces
% 
%  A: sparse matrix, nv x nv, discretized generalized laplacian operator
%
%% Contribution
%  Author : Wen Cheng Feng
%  Created: 2014/03/03
%  Revised: 2014/03/23 by Wen, add doc
% 
%  Copyright 2014 Computational Geometry Group
%  Department of Mathematics, CUHK
%  http://www.math.cuhk.edu.hk/~lmlui

function [A,abc,area] = generalized_laplacian(face,vertex,mu)


af = (1-2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
bf = -2*imag(mu)./(1.0-abs(mu).^2);
gf = (1+2*real(mu)+abs(mu).^2)./(1.0-abs(mu).^2);
abc = [af,bf,gf];

f0 = face(:,1);
f1 = face(:,2);
f2 = face(:,3);

%coord. of edges of the original mesh, y-coord of the opposite edge of v0
%is denoted uxv0, etc. The triangle is oriented 0,1,2; but the y-coord is
%oriented reversly in order to calculate the outward normal
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
A = sparse(I,J,-V);
end
