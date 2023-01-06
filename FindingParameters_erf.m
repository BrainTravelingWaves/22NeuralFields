function [a,c,t,T,exitflag] = FindingParameters_erf(eps,th,err,a_init,c_init)

%Finding parameters a and c for the Gaussian connectivity function
% c<0 speed of travelling wave
% a>0 intersectinon with x = th
% exitflag allows to monitor if fsolve found solution
% b2=1/(T-t), where T and t are calculated axes trunction with given err

clambda_1 =(1-sqrt(1-4*eps))/(2);
clambda_2 =(1+sqrt(1-4*eps))/(2);

p11= (-1+sqrt(1-4*eps))/(2*eps); 
p21= (-1-sqrt(1-4*eps))/(2*eps);

A1=p11/(p11-p21);
A2=p21/(p11-p21);

expA10=@(t,c) A1*exp(clambda_1*t/c)-A2*exp(clambda_2*t/c);

funU10=@(x,a,c) - 1/c * integral(@(y) expA10(x-y,c).*(erf(y)-erf(y-a)),-Inf,x); % x, Inf

options = optimset;
opt_for_ac = optimset(options,'TolX',1e-8, 'TolFun',1e-8, 'Display','off');
optU= @(X,th) [funU10(0,X(1),X(2))-th funU10(X(1),X(1),X(2))-th];

opt_for_Tt = optimset(options,'TolX',1e-8, 'TolFun',1e-12, 'Display','off');
opt0= @(x,a,c,err) funU10(x,a,c)-err;

[X,~,exitflag,~] = fsolve(@(x) optU(x,th), [a_init,c_init],opt_for_ac);% need a good guess here!

if exitflag==1
    a=X(1); c=X(2);
    
    [T,fvalT,exitflagT,~] = fsolve(@(x) opt0(x,a,c,-err), 20,opt_for_Tt); 
        
    [t,fvalt,exitflagt,~] = fsolve(@(x) opt0(x,a,c,err), -0.1,opt_for_Tt);
    
else
    a=nan; c=nan; t=nan; T=nan;
end
   



end