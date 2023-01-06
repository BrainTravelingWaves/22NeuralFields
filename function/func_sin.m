function [ funcY,ttt ] = func_sin( N )
% Func Sinus
sample=pi/N*2;
%x=-pi:sample:pi;
ttt=0:sample:2*pi-sample;
funcY=sin(ttt);
end

