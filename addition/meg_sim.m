%% SER PARAM
PARAM.T=0.1;         % period 100 ms
PARAM.frqu=18;       % basis frequency 
PARAM.SR=500;        % rate EEG or MEG signal
PARAM.N_step=50;     % points of signal model
PARAM.ca=1.1125e-09; % 1 A (50 nA/mm2)
PARAM.v=0.2;         % the traveling wave velocity (m/s)
PARAM.max_dist=0.02; % wave spreding (m)
Nblock=100;
% Anatom !!! AAA=precalcdist(cortex); % only Brainstorm run
AAA=Al;
cortex=corL;
Gain=OSphL.Gain;
Nvert=size(cortex.Vertices,1);
% clear gain
Gain(1:2,:)=0;
Gain(301:302,:)=0;
% Select of vertices
Vscout=Scouts.Vertices;
Nscout=size(Vscout,2);
% Set time
tt=0:1/PARAM.SR:PARAM.N_step/PARAM.SR-1/PARAM.SR;
Ypi=2*pi*PARAM.T*PARAM.frqu;
% Maps of amplitude
amp_dip=zeros(size(cortex.Vertices,1),PARAM.N_step);
meeg_save=zeros(size(Gain,1),PARAM.N_step,Nblock);

jjj=1;
iBlock=1;
for iii=1:Nscout
  dist=graphshortestpath(AAA,Vscout(iii),'Directed', false);
  for kk=1:Nvert
    if dist(kk)<=PARAM.max_dist  
     for ii=2:PARAM.N_step
       for jj=1:ii
         if dist(kk)<=(tt(jj)*PARAM.v)
          ttt=tt(ii)-dist(kk)/PARAM.v;    
          amp_dip(kk,ii)=sin(Ypi*ttt/PARAM.T); %sin(2*pi*ttt/PARAM.T); 
          %amp_dip(kk,ii)=WP(ttt/PARAM.T);
         end
       end
     end
    end
  end
  meeg_save(:,:,jjj)=meeg_create(cortex_eldp(cortex,amp_dip,PARAM.N_step),Gain);
  jjj=jjj+1;
  if jjj>Nblock
    jjj=1;  
    save(strcat('MEGstfL',num2str(iBlock)),'meeg_save');
    iBlock=iBlock+1;
    meeg_save=zeros(size(Gain,1),PARAM.N_step,Nblock);
  end
end