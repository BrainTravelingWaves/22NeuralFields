N=50;
fr=18;
T=1/fr; % 2pi
t=0.1;
%Ypi=2*pi*t/T;
Ypi=2*pi*t*fr;
%sample=2*pi/N;
sample=Ypi/N;
ttt=0:sample:Ypi-sample;
funcY=zeros(N,1);
for i=1:50
  funcY(i)=sin(ttt(i));
end
plot(ttt,funcY)
grid on