function q = p2c(p)

% P2C  Polygon to Complex
%   q = P2C(p) converts p to complex numbers if p is a N-by-2 matrix.
%
%   q = P2C(p) converts p to a N-by-2 matrix consisting of coordinates on
%   complex plane if p is a vector of complex numbers.

if size(p, 2) > 1
  q = complex(p(:, 1), p(:, 2));
else
  q = [real(p), imag(p)];
end
