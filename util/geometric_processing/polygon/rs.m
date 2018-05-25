function q = rs(n, var, rep, mode)

% RS  Random shape
%   q = RS(n, var, rep) generates a random polygon with n sides.
% 
%   q = RS(n, var, rep, 'complex') returns the polygon on complex plane.

t = linspace(0, 2*pi, n+1)';
t(end) = [];
r = ones(n, 1);
for i = 1:rep
  r = r+.5*randn*sin(randi(var)*t+randn)/rep;
end
q = [r.*cos(t), r.*sin(t)];
if nargin == 4 && strcmp(mode, 'complex')
  q = complex(q(:, 1), q(:, 2));
end
