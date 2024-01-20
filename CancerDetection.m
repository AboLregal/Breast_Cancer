function i2=CancerDetection(i)

k=i>=255*0.75;
k=medfilt2(k,[17 17]);
k=bwareaopen(k,300);
i2=bwfill(k,'holes');
