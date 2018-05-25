function count = overlap(mu,arg)

if nargin < 2
    count = sum(abs(mu) >= 1);
else
    count = sum(abs(mu) >= arg);
end

end