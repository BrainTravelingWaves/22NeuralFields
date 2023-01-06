function [meeg] = meeg_create(ElemDip,Gain)
%Create EEG or MEG
    Nstep=size(ElemDip,3);
    meeg=zeros(size(Gain,1),Nstep);
    for i=1:Nstep
        meeg(:,i)=Gain*reshape(((ElemDip(:,:,i)))',size(Gain,2),1);
    end
end