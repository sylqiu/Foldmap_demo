function U = my_arap(V,F,XI,YI,constraints)
  b = constraints(:,1)';
  bc = constraints(:,2:3); 
  max_iterations = 2;
  tol = 0.0001;
  U = my_asap(V,F,XI,YI,constraints);
  % average edge length, helps later to keep tolerance somewhat domain
  % independent
  h = avgedge(V,F);

  % number of vertices
  n = size(V,1);
  % number of dimensions
  dim = size(V,2);
  % only works in 2D
  assert(dim == 2)
  % number of triangles
  nt = size(F,1);
  
   % reshape coordinate into single tall column
    XI = reshape(XI,size(F,1)*3,1);
    YI = reshape(YI,size(F,1)*3,1);
    
  % indices of each triangle
  t = 1:nt;
  % indices of three corners of each triangle as seen by other corners
  ti = [t+(1-1)*nt t+(2-1)*nt t+(3-1)*nt];
  tj = [t+(2-1)*nt t+(3-1)*nt t+(1-1)*nt];
  tk = [t+(3-1)*nt t+(1-1)*nt t+(2-1)*nt];
  % indices to each triangle
  i = [F(t,1);F(t,2);F(t,3)]';
  j = [F(t,2);F(t,3);F(t,1)]';
  k = [F(t,3);F(t,1);F(t,2)]';
  % Rename for convenience
  xi = XI(ti);
  yi = YI(ti);
  xj = XI(tj);
  yj = YI(tj);
  xk = XI(tk);
  yk = YI(tk);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % Prepare fitting system
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % quadratic part
  QI = [[ti ti+3*nt]'; [ti ti+3*nt]'; [tj tj+3*nt]';[ti ti+3*nt]';[tj+3*nt tj]'];  
  QJ = [[ti ti+3*nt]'; [tj tj+3*nt]'; [ti ti+3*nt]';[tj+3*nt tj]';[ti ti+3*nt]'];  
  QV = [ ...
    (1- 2*[xk;xk] + [xk;xk].^2 + [xj;xj].^2 + [-yk;yk].^2 + [-yj;yj].^2) ;...
    (-[xk;xk].^2 +[xk;xk]-[-yk;yk].^2); ...
    (-[xk;xk].^2 +[xk;xk]-[-yk;yk].^2); ...  
    ([yk;-yk]); ...
    ([yk;-yk]); ...
    ];
  Qfit = sparse(QI,QJ,QV,2*3*nt,2*3*nt);
  % prepare fitting output
  UF = zeros(3*nt,dim);

  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  %
  % Prepare poisson solve
  %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % cotan weights
  Lcot = cotmatrix(V,F);
  % quadratic coefficients
  QI = [j j i i]';
  QJ = [j i j i]';
  QV = [ ...
       Lcot(sub2ind(size(Lcot),i,j)'); ...
      -Lcot(sub2ind(size(Lcot),i,j)'); ...
      -Lcot(sub2ind(size(Lcot),i,j)'); ...
       Lcot(sub2ind(size(Lcot),i,j)')];
  Qpoi = sparse(QI,QJ,QV,n,n);
  %Q = -Lcot;

  
  iteration = 0;
  U1 = V;
  while( iteration < max_iterations && (iteration == 0 || max(abs(U(:)-U1(:)))>tol*h))
    U1 = U;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Construct and solve fitting problem
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % repeat each vertex for each triangle corner
    U1F = [U1(F(:,1),:);U1(F(:,2),:);U1(F(:,3),:)];
    % linear part for fitting
    Lfit = ...
      -2*(U1F([tk tk+3*nt]').*(1 - [xk;xk]) + ...
      U1F([tj tj+3*nt]').*([xj;xj]) + ...
      U1F([tk+3*nt tk]').*(-[-yk;yk]) + ...
      U1F([tj+3*nt tj]').*([-yj;yj]));
    % solve
    UF(:) = min_quad_with_fixed(Qfit,Lfit,[],[]);
    % ratio of old size to new size
    ratioF = ...
      sqrt(sum((V(F(:,1),:)-V(F(:,2),:)).^2,2))./ ...
      sqrt(sum((UF(t,:)-UF(t+nt,:)).^2,2));
    % repeat for each coordinate
    ratioF = repmat(ratioF,1,2);
    % centers of mass
    cmF = (UF(t,:) + UF(t+nt,:) + UF(t+2*nt,:))/3;
    % scale each triangle to original size around its center of mass
    UF(t,:)      = cmF + ratioF.*(UF(t     ,:) - cmF);
    UF(t+nt,:)   = cmF + ratioF.*(UF(t+nt  ,:) - cmF);
    UF(t+2*nt,:) = cmF + ratioF.*(UF(t+2*nt,:) - cmF);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Construct and solve poisson problem
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % linear coefficients of poison problem
    LI = [i i];
    LJ = [ones(3*nt,1) 2*ones(3*nt,1)];
    LV = [ ...
      2*(repmat(Lcot(sub2ind(size(Lcot),i,j)'),1,2).* ...
        (UF(tj,:) - UF(ti,:)) - ...
      repmat(Lcot(sub2ind(size(Lcot),k,i)'),1,2).* ...
      (UF(ti,:) - UF(tk,:)))];
    Lpoi = sparse(LI(:),LJ(:),LV(:),n,2);
    % solve in each coordinate
    U(:,1) = min_quad_with_fixed(Qpoi,Lpoi(:,1),b,bc(:,1));
    U(:,2) = min_quad_with_fixed(Qpoi,Lpoi(:,2),b,bc(:,2));
    
    % increment iteration counter
    iteration = iteration + 1;
  end

end