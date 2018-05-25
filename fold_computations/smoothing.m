function smooth_mu = smoothing(mu,Smooth_Operator,Operator)

vmu = Operator.f2v*mu;
nvmu = Smooth_Operator\abs(vmu);
vmu = nvmu.*(cos(angle(vmu))+sqrt(-1)*sin(angle(vmu)));
smooth_mu = Operator.v2f*vmu;

end