function i=CutBreast(i)

s=sum(i(1:200,:)');
s=s/max(s);
v=var(s);
if v>1e-3
    i(1:100,:)=0;
end
[rows,cols]=size(i);
xcord=[1 1 cols*.35];
ycord=[rows*.35 1 1];
msk=poly2mask(xcord,ycord,rows,cols);
i2=activecontour(i,msk);
i=immultiply(i,~i2);