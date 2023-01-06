function [ElemDip] = cortex_eldp(mesh, Amp, Nstep)
%% Load mesh
Vertices=mesh.Vertices;
VertNormals = mesh.VertNormals;
%% Create dipe
ElemDip=zeros(size(Vertices,1),size(Vertices,2),Nstep);
for i=1:Nstep 
    ElemDip(Amp(:,i)~=0,:,i)=(VertNormals(Amp(:,i)~=0,:).*repmat(Amp(Amp(:,i)~=0,i),1,3));
end
end