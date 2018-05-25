function U = my_asap(V,F,XI,YI,constraints)
b = constraints(:,1)';
bc = constraints(:,2:3); 
L = length(XI(:,1));
% reshape coordinate into single tall column
  XI = reshape(XI,L*3,1);
  YI = reshape(YI,L*3,1);
  % number of vertices
  n = size(V,1);
  % only works in 2D
  assert(size(V,2) == 2)
  % number of triangles
  nt = size(F,1);
  

  % Indices of each triangle vertex, I, and its corresponding two neighbors, J
  % and K
  I = [F(:,1);F(:,2);F(:,3)];
  J = [F(:,2);F(:,3);F(:,1)];
  K = [F(:,3);F(:,1);F(:,2)];
  % rename indices to so that I1 and I2 and so on index into vertex positions
  % as single column. Namely V(I,1) = V(I1) and V(I,2) = V(I2) etc.
  I1 = I;
  I2 = I+n;
  J1 = J;
  J2 = J+n;
  K1 = K;
  K2 = K+n;

  % Construct quadratic system matrix each triplet from II,JJ,VV contains an
  % set of elements per vertex per triangle in the quadratic energy summation
  II = [ ...
    J1,J2,J1,K1,J1,K2,J2,K1,J2,K2,K1,K2,I1,J1,I1,J2,I2,J1,I2,J2,I1,I2,I1,K1,I1,K2,I2,K1,I2,K2
    ];
  JJ = [
    J1,J2,K1,J1,K2,J1,K1,J2,K2,J2,K1,K2,J1,I1,J2,I1,J1,I2,J2,I2,I1,I2,K1,I1,K2,I1,K1,I2,K2,I2
    ];
  VV = [ ...
    (1-2*XI+XI.^2+YI.^2)
    (1-2*XI+XI.^2+YI.^2)
    (XI-XI.^2-YI.^2)
    (XI-XI.^2-YI.^2)
    (YI)
    (YI)
    (-YI)
    (-YI)
    (XI-XI.^2-YI.^2)
    (XI-XI.^2-YI.^2)
    (XI.^2+YI.^2)
    (XI.^2+YI.^2)
    (-1+XI)
    (-1+XI)
    (YI)
    (YI)
    (-YI)
    (-YI)
    (-1+XI)
    (-1+XI)
    ones(nt*3,1)
    ones(nt*3,1)
    (-XI)
    (-XI)
    (-YI)
    (-YI)
    (YI)
    (YI)
    (-XI)
    (-XI)
    ];
  % Assembly matrix
  A = sparse(II,JJ,VV,2*n,2*n);

  % solve
%   U = min_quad_with_fixed(A,zeros(2*n,1),[b b+n],bc(:));
  bb = -A(:,[b, b+n])*bc(:);
  bb([b, b+n],:) = bc(:);
  A([b, b+n],:) = 0; 
  A(:,[b, b+n]) = 0;
  A = A + sparse([b, b+n],[b, b+n],ones(length([b, b+n]),1), size(A,1), size(A,2));
  U = A\bb;
  % reshape into columns
  U = reshape(U,n,2);

 

end