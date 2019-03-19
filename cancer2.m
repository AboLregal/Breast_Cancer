clc;clear;close all

%% Getting Image

i=imread('mdb107.pgm');
figure(1)
imshow(i);title('Original Photo')

% if image is rgb
try
    i=rgb2gray(i);
end

%% Crop The Breast

z=im2bw(i,0.1);
figure(2)
imshow(z);title('Original B&W')
info=regionprops(z);
a=cat(1,info.Area);
[m,l]=max(a);
X=info(l).Centroid;
bw2=bwselect(z,X(1),X(2),8);
i=immultiply(i,bw2);
figure(3)
imshow(i);
title('Getting the Breast and Muscle')

%% Deleting Black Ground

% We will delete the black corners
% So that we can select the muscle
% using bwselect
% convert to B&W first time
[x,y]=size(z);
tst1=zeros(x,y);

% detect empty rows
r1=[];
m=1;
for j=1:x
    if z(j,:)==tst1(j,:)
        r1(m)=j;
        m=m+1;
    end
end

% detect empty columns
r2=[];
m=1;
for j=1:y
    if z(:,j)==tst1(:,j)
        r2(m)=j;
        m=m+1;
    end
end

% Deleting
i(:,r2)=[];
i(r1,:)=[];

figure(4)
imshow(i);title('after deleting background');


%% Deleting the Muscle

if i(1,1)~=0
    c=3;
    r=3;
else
    r=3;
    c=size(i,2)-3;
end

z2=im2bw(i,0.5);
bw3=bwselect(z2,c,r,8);
bw3=~bw3;
ratio=min(sum(bw3)/sum(z2));
if ratio>=1
    i=immultiply(i,bw3);
else
    z2=im2bw(i,0.75);
    bw3=bwselect(z2,c,r,8);
    ratio2=min(sum(bw3)/sum(z2));
    if round(ratio2)==0
        lvl=graythresh(i);
        z2=im2bw(i,1.75*lvl);
        bw3=bwselect(z2,c,r,8);
        bw3=~bw3;
        i=immultiply(i,bw3);
    else
        bw3=~bw3;
        i=immultiply(i,bw3);
    end
end
figure(5)
imshow(i)
title('Getting only the Breast')

%% Weiner Filter

% We will create average mask [3 3]
% with SNR = 0.2
mask=fspecial('average',[3 3]);
SNR=0.2;
i=deconvwnr(i,mask,SNR);
figure(6)
imshow(i)
title('Weiner Filter')

%% Clahe Filter

i=adapthisteq(i);
figure(7)
imshow(i)
title('Clahe Filter')