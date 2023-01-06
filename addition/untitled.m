cortex=corL;
Npoint=length(U);
time_point=linspace(0,0.1,Npoint);
amp_dip=zeros(size(cortex.Vertices,1),PARAM.N_step);     
for kk=1:size(cortex.Vertices,1)
  if dist(kk)<=PARAM.max_dist  
  for ii=2:PARAM.N_step
     for jj=1:ii
       if dist(kk)<=(tt(jj)*PARAM.v)
          ttt=tt(ii)-dist(kk)/PARAM.v;    
          %amp_dip(kk,ii)=sin(2*pi*ttt/PARAM.T);
          t_p=time_point-ttt/PARAM.T;
          [min_t,min_tt]=min(abs(t_p));
          amp_dip(kk,ii)=U(min_tt);
       end
     end
  end
  end
end