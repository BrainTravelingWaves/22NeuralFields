%% Load MEGs
sig=m.F(:,301:500);
% Clear MEGs
sig(1:2,:)=0;
sig(301:302,:)=0;
%% Select of vertices
Vscout=Scouts.Vertices;
Nscout=size(Vscout,2);
for i=1:Nscout
    load(strcat('MEGstfL',num2str(i),'.mat','sim');
    for j=1:Nstep
        sim_seg=meeg_save(:,k:k+10,l)
    amp_dip=zeros(size(cor.Vertices,1),Nstep,);
    dist=graphshortestpath(A,Vscout(i),'Directed', false);
    for j=1:size(dist,2)
        if dist(j)<PARAM.dis
            for k=1:PARAM.Nstep
                t=k*dt;
                
                %for l=1:k
                 %  if dist(j)<(l*dt*PARAM.vel) 
                      amp_dip(j,k)=wave_form(k);%(PARAM.Nstep-l+1);
                 %  end
                %end
            end
        end
    end
    eldp=cortex_eldp(cor,amp_dip,Nstep);
    meegplmn=meeg_create(eldp,GGG.Gain);
end
toc