function F=extract_features(im)

%% Pre-Processing Image

im=RotatingBreast(im);
im=CutBreast(im);

% if image is rgb
try
    im=rgb2gray(im);
end

%% Clean The Image

z=im2bw(im,0.1);
info=regionprops(z);
a=cat(1,info.Area);
[m,l]=max(a);
X=info(l).Centroid;
bw2=bwselect(z,X(1),X(2),4);
im=immultiply(im,bw2);



%% Weiner Filter

% We will create average mask [3 3]
% with SNR = 0.2
mask=fspecial('average',[3 3]);
SNR=0.2;
im=deconvwnr(im,mask,SNR);

%% Clahe Filter

im=adapthisteq(im);

%% Detect Cancer
i2=CancerDetection(im);

%% Features
info=regionprops(i2,'all');

%% Number of White Spots
F(1)=length(info);
if F(1)==0
    F=zeros(1,60);
    return
end

%% Area Features
Ar=cat(1,info.Area);
F(2)=max(Ar);
F(3)=mean(Ar);
F(4)=var(Ar);
F(5)=geomean(Ar);

%% Centroid Distances
C=cat(1,info.Centroid);
D=[];
for i=1:F(1)
    for j=i+1:F(1)
        D=[D norm(C(i,:)-C(j,:))];
    end
end
if ~isempty(D)
F(6)=max(D);
F(7)=min(D);
F(8)=mean(D);
F(9)=var(D);
F(10)=geomean(D);
end

%% Major Axis
Mjr=cat(1,info.MajorAxisLength);
F(11)=max(Mjr);
F(12)=min(Mjr);
F(13)=mean(Mjr);
F(14)=var(Mjr);
F(15)=geomean(Mjr);

%% Minor Axis
Mnr=cat(1,info.MinorAxisLength);
F(16)=max(Mnr);
F(17)=min(Mnr);
F(18)=mean(Mnr);
F(19)=var(Mnr);
F(20)=geomean(Mnr);

%% Radius Precentage
r_per=Mnr./Mjr;
F(21)=max(r_per);
F(22)=sum(r_per>0.85)/F(1);
F(23)=mean(r_per);
F(24)=var(r_per);
F(25)=geomean(r_per);

%% Image Intensity
im2=double(im)/255;
for i=1:F(1)
   ix=bwselect(i2,C(i,1),C(i,2));
   ixx=im2.*ix;
   In(i,1)=sum(ixx(:))/sum(ix(:));
end
In(isnan(In))=[];
F(26)=max(In);
F(27)=sum(In);
F(28)=mean(In);
F(29)=var(In);
F(30)=geomean(In);

%% Ellipse Eccentricity
es=cat(1,info.Eccentricity);
F(31)=max(es);
F(32)=sum(es);
F(33)=mean(es);
F(34)=var(es);
F(35)=geomean(es);

%% Angels Orinations
or=abs(cat(1,info.Orientation));
F(36)=max(or);
F(37)=sum(or);
F(38)=mean(or);
F(39)=var(or);
F(40)=geomean(or);

%% Equiv Diameter
ed=cat(1,info.EquivDiameter);
F(41)=max(ed);
F(42)=sum(ed);
F(43)=mean(ed);
F(44)=var(ed);
F(45)=geomean(ed);

%% Convex Area
ca=cat(1,info.ConvexArea);
F(46)=max(ca);
F(47)=sum(ca);
F(48)=mean(ca);
F(49)=var(ca);
F(50)=geomean(ca);

%% Circularity
circ=cat(1,info.Circularity);
F(51)=max(circ);
F(52)=sum(circ);
F(53)=mean(circ);
F(54)=var(circ);
F(55)=geomean(circ);

%% Perimeter
pr=cat(1,info.Perimeter);
F(56)=max(pr);
F(57)=sum(pr);
F(58)=mean(pr);
F(59)=var(pr);
F(60)=geomean(pr);

