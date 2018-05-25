function q = fp(p)

% FP  Flip polygon.
%   q = FP(p) flips the polygon defined by vertices p under the map 1/z.

z = complex(p(:,1), p(:,2));
z = 1./z;
q = [real(z), imag(z)];