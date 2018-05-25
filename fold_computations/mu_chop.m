function mu_new = mu_chop(mu,bound,target)

mu_new = mu;
ind = abs(mu)>=bound;
mu_new(ind) = target*(cos(angle(mu(ind)))+1i*sin(angle(mu(ind))));