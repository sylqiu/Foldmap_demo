function my_patchtop(FF, VV, TF, VT, occ_face_ind, I, sizep, sigma)
% 
%   PATCHTOP(FF, VV, TF1, VT1, TF2, VT2, I, sizep=128, sigma=1.6)
%   FF,VV: mesh to be textured
%   TF,CT: texture coordinate for un-occluded faces
%   occ_face_ind: indices of those occluded faces
%     sizep: size of patch
%     sigma: sigma for Gaussian smoothing

if size(VV, 2) == 2
  VV(1, 3) = 0;
end

if ~exist('sizep', 'var')
  sizep = 128;
end

if ~exist('sigma', 'var')
  sigma = 1.6;
end

% Check input sizes
if size(FF,2) ~= size(TF,2)
    error('patcht:inputs','Face list must be equal in size to texture-index list');
end

if ndims(I) == 1 || ndims(I) > 3
    error('patcht:inputs','No valid Input texture image');
end

if size(I, 3) == 1
  I(:, :, 2) = I(:, :, 1);
  I(:, :, 3) = I(:, :, 1);
elseif size(I, 3) ~= 3
  error('patcht:inputs','No valid Input texture image');
end
   
if max(VT(:)) < 2
    % Remap texture coordinates to image coordinates
    VT2(:,1) = (size(I,1)-1)*(VT(:,1))+1;
    VT2(:,2) = (size(I,2)-1)*(VT(:,2))+1;
else
    VT2 = VT;
end

% Calculate the texture interpolation values
l = linspace(1, 0, sizep+1);
[lam2, lam3] = meshgrid(l, l);
lam2 = lam2(:)';
lam3 = lam3(:)';
lam1 = 1-lam2-lam3;

% Split texture-image in r,g,b to allow fast 1D index 
Ir = I(:,:,1);
Ig = I(:,:,2);
Ib = I(:,:,3);

% The Patch used for every triangle (rgb)
% Jr = zeros([(sizep+1) (sizep+1) 1], class(I));
% Jg = zeros([(sizep+1) (sizep+1) 1], class(I));
% Jb = zeros([(sizep+1) (sizep+1) 1], class(I));

hold on; axis equal
% Loop through all triangles of the mesh;
nff = size(FF,1);
v = [VV(FF(:, 1), :), VV(FF(:, 2), :), VV(FF(:, 3), :)];
vt = [VT2(TF(:, 1), :), VT2(TF(:, 2), :), VT2(TF(:, 3), :)];
ax = [v(:, 1), v(:, 7), v(:, 4), v(:, 7)];
ay = [v(:, 2), v(:, 8), v(:, 5), v(:, 8)];
az = [v(:, 3), v(:, 9), v(:, 6), v(:, 9)];
px = round(vt(:, 1)*lam1+vt(:, 3)*lam2+vt(:, 5)*lam3);
py = round(vt(:, 2)*lam1+vt(:, 4)*lam2+vt(:, 6)*lam3);
px = min(size(I, 1), max(1, px));
py = min(size(I, 2), max(1, py));
id = px+(py-1)*size(I, 1);
J2 = repmat(rand(30,30),1,1,3);
for i = 1 : nff
    if ismember(i,occ_face_ind)
        x = reshape(ax(i, :), 2, 2);
        y = reshape(ay(i, :), 2, 2);
        z = reshape(az(i, :), 2, 2);
        surface(x, y, z, J2, 'FaceColor', 'texturemap');
    else
        x = reshape(ax(i, :), 2, 2);
        y = reshape(ay(i, :), 2, 2);
        z = reshape(az(i, :), 2, 2);
        J(:,:,1) = rot90(reshape(Ir(id(i, :)), sizep+1, sizep+1), 2); 
        J(:,:,2) = rot90(reshape(Ig(id(i, :)), sizep+1, sizep+1), 2); 
        J(:,:,3) = rot90(reshape(Ib(id(i, :)), sizep+1, sizep+1), 2);
        if sigma > 0
        J = imgaussfilt(J, sigma);
        end
%         imshow(J);
        surface(x, y, z, J, 'FaceColor', 'texturemap');
    end
end
hold off;