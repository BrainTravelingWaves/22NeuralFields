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
             amp_dip(k,i)=sin(2*pi/0.1*tt);
          end
       end
    end
end
%%
c.ImageGridAmp=amp_dip;
%%
s_meg=emeg_sim0(MEGbemL,cortex_eldip(cortex,amp_dip,PARAM));
m.F=s_meg;