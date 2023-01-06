clear; clc
% construction of travelling waves, Heaviside
%
% -cU'=-U+ int w(x-y) H(U-th)dy -v
% -cV=eps*U  (- beta*V ==0 here)
% Then:
% U(x)=(1/2*c) int_x^{\infty} Pexp(lambda_1(x-y)+exp(lambda_2(x-y)))inv(P)*(W(y)-W(y-a))dy
% e.g. W(y)=erf(y)
% lambda_1=(1+sqrt(1-4*eps))/(2*c);
% lambda_2=(1-sqrt(1-4*eps))/(2*c);



%%%%          Model parameters block

eps = 0.2;    %  negative feedback
th = 0.5;     %  neuronal activation threshold
b1 = 2;       %  neuronal connection strenghts 

err=5e-3;     %  truncation error/tolerance



a_init=0.5;     % initial guess for the wave super-threshold width
c_init=-0.2;    % initial guess for the wave speed (<0)


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


th0= th/b1; err0=err/b1;

[a0,c0,t,T,exitflag] = FindingParameters_erf(eps,th0,err0,a_init,c_init);

b2=1/(T-t);
a=a0*b2; c = c0*b2;

%%
clambda_1 =(1-sqrt(1-4*eps))/(2);
clambda_2 =(1+sqrt(1-4*eps))/(2);

p11= (-1+sqrt(1-4*eps))/(2*eps); 
p21= (-1-sqrt(1-4*eps))/(2*eps);

A1=p11/(p11-p21);
A2=p21/(p11-p21);

expA10=@(t,c) A1*exp(clambda_1*t/c)-A2*exp(clambda_2*t/c);

funU10=@(x,a,c) - 1/c * integral(@(y) expA10(x-y,c).*(erf(y)-erf(y-a)),-Inf,x); % x, Inf

%%
N=500;
x=linspace(0,1,N);
if exitflag==1
     y=x/b2;
     for i=1:length(x)
         U(i)=b1*funU10(y(i)+t,a0,c0);
     end
     figure(100)
     grid on
     hold on
     hoh= plot(x,U);
     plot(x,x*0+th,'--')
     plot([0-t*b2 a-t*b2], [th th],'o')
     legend(hoh,['c=',num2str(c')],'Location','northeast')
     xlabel('x-ct')
     ylabel('U(x-ct)')
     title(['Travelling pulse for h=', num2str(th),'(dashed), \epsilon=', num2str(eps),' and b_1=',num2str(b1)])
     
 else
     disp('*********************')
     disp('No solution found!')
     disp('Suggestion: Decrease either the threshold or epsilon')
end
 
% Save output

%  save('profile.mat','x','U')

%  New profile function w2

WP=@(r)interp1(x,U,r);

%%%%%%%    Check interpolated profile plot
% figure(2)
% y=linspace(0,1,700);
% plot(y,WP(y));

%%
%%Tables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc

disp('-----------------------------------------------------------------------------------')
disp('                            Your Input:')
disp('-----------------------------------------------------------------------------------')
fprintf('      eps       h     trunc.error   b1\n')
format short
disp([eps,th,err,b1])


fprintf('\n')
disp('                                Output:')
disp('-----------------------------------------------------------------------------------')
fprintf('      T-t       b2         a         c        x0        x0+a     U(0)     U(1)\n')
format short
disp([T-t,b2,a,c,-t*b2,-t*b2+a,U(1),U(end)])
disp('-----------------------------------------------------------------------------------')

%%
% LOAD WAVE and MEG 

PARAM.w_frequ=10;    % Hz find FFT spectr
PARAM.SR=500;        % rate EEG or MEG signal
PARAM.N_step=50;     % points of signal model
PARAM.ca=1.1125e-09; % 1 A (50 nA/mm2)
PARAM.v_wave=0.2;    % the traveling wave velocity (m/s)
PARAM.max_dist=0.02; % wave spreding (m)
%%
v=41941;
A=Al;
cortex=cortL;
dist=graphshortestpath(A,v,'Directed', false);
%%
t=0:1/PARAM.SR:PARAM.N_step/PARAM.SR-1/PARAM.SR;
%x=0:2*pi/PARAM.N_step:2*pi-pi/PARAM.N_step;
%x=sin(x);
%%
amp_dip=zeros(size(cortex.Vertices,1),PARAM.N_step);
d1=0;
for i=2:PARAM.N_step
    for j=1:i
       for k=1:size(cortex.Vertices,1)
          if dist(k)<=(t(j)*PARAM.v_wave)
             tt=t(i)-dist(k)/PARAM.v_wave;    
             amp_dip(k,i)=WP(tt/0.1);
          end
       end
    end
end
%%
cor.ImageGridAmp=amp_dip;  % load wave 100 msec
%%
s_meg=emeg_sim0(MEGsphL,cortex_eldip(cortex,amp_dip,PARAM));
meg.F(1:306,:)=s_meg;               % load MEG