N=50;
fr=18;
T=1/fr; % 2pi
t=0.1;
%Ypi=2*pi*t/T;
Ypi=2*pi*t*fr;
%sample=2*pi/N;
sample=Ypi/N;
ttt=linspace(0,Ypi,N);
%ttt=0:sample:Ypi-sample;
tt=linspace(0,0.1,N);
%tt=0:0.002:0.1-0.002;
funcY=zeros(N,1);
for i=1:50
  funcY(i)=sin(ttt(i));
end
figure(1)
plot(tt,funcY)
grid on