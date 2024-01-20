clc;clear;close all

%% Getting Image

% i=imread('mdb107.pgm');
[fle,pth]=uigetfile('*.pgm');
i=imread([pth,fle]);

i=RotatingBreast(i);
i=CutBreast(i);
figure()
imshow(i);title('Original Photo')

% if image is rgb
try
    i=rgb2gray(i);
end

%% Clean The Image

z=im2bw(i,0.1);
figure()
imshow(z);title('Original B&W')
info=regionprops(z);
a=cat(1,info.Area);
[m,l]=max(a);
X=info(l).Centroid;
bw2=bwselect(z,X(1),X(2),4);
i=immultiply(i,bw2);
figure()
imshow(i);
title('Getting the Breast and Muscle')



%% Weiner Filter

% We will create average mask [3 3]
% with SNR = 0.2
mask=fspecial('average',[3 3]);
SNR=0.2;
i=deconvwnr(i,mask,SNR);
figure()
imshow(i)
title('Weiner Filter')

%% Clahe Filter

i=adapthisteq(i);
figure()
imshow(i)
title('Clahe Filter')

%% Detect Cancer
i2=CancerDetection(i);
figure()
subplot(1,2,1)
imshowpair(i,i2)
subplot(1,2,2)
imshowpair(i,i2,'montage')