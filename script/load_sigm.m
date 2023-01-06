%%%%% LOAD SIGMOID
PARAM.T=0.1;         % period 100 ms
PARAM.SR=500;        % rate EEG or MEG signal
PARAM.N_step=50;     % points of signal model
PARAM.ca=1.1125e-09; % 1 A (50 nA/mm2)
PARAM.v=0.2;         % the traveling wave velocity (m/s)
PARAM.max_dist=0.01; % wave spreding (m)
%% Al=precalcdist(corL); % only Brainstorm run
vert=28025;
AAA=Alr;
cortex=cV1L;
dist=graphshortestpath(AAA,vert,'Directed', false);
%%
tt=0:1/PARAM.SR:PARAM.N_step/PARAM.SR-1/PARAM.SR;
%x=0:2*pi/PARAM.N_step:2*pi-pi/PARAM.N_step;
%x=sin(x);
%% sinus
tic
amp_dip=zeros(size(cortex.Vertices,1),PARAM.N_step);
%d1=0;
for ii=2:PARAM.N_step
    for jj=1:ii
       for kk=1:size(cortex.Vertices,1)
          if dist(kk)<=(tt(jj)*PARAM.v)
             ttt=tt(ii)-dist(kk)/PARAM.v;    
             %amp_dip(kk,ii)=WP(ttt/PARAM.T);
             amp_dip(kk,ii)=sin(2*pi*ttt/PARAM.T);             
          end
       end
    end
end
toc
%% sigma
tic 
amp_dip=zeros(size(cortex.Vertices,1),PARAM.N_step);     
for kk=1:size(cortex.Vertices,1)
  if dist(kk)<=PARAM.max_dist  
   for ii=2:PARAM.N_step
     for jj=1:ii
       if dist(kk)<=(tt(jj)*PARAM.v)
          ttt=tt(ii)-dist(kk)/PARAM.v;    
          amp_dip(kk,ii)=WP(ttt/PARAM.T);
          %amp_dip(kk,ii)=sin(2*pi*ttt/PARAM.T);
       end
     end
   end
  end
end
toc
%%
%load('OSphL.mat','OSphL');
%% clear gain
%OSphL.Gain(1:2,:)=0;
%OSphL.Gain(301:302,:)=0;
%%
% eldp=cortex_eldp(cortex,amp_dip,PARAM.N_step);
% meeg=meeg_create(eldp,OSphL.Gain);
%%
tic
meegs=meeg_create(cortex_eldp(cortex,amp_dip,PARAM.N_step),OsL.Gain);
toc
%%
meg.F=meegs;
%%
cor.ImagingKernel=[];
cor.ImageGridAmp=amp_dip;  % load wave 100 msec
%%
%s_meg=emeg_sim0(MEGsphL,cortex_eldip(cortex,amp_dip,PARAM));
%meg.F(1:306,:)=s_meg;               % load MEG