clc;
clear; 
close all;
k=1;
img=imread('lena_watermark.bmp');
for z=1:100
    name=['D:\大三上\数字内容安全\project\jpeg\',num2str(z),'lena_watermark.jpg'];
    imwrite(img,name,'quality',z);
end
for z=1:100
    im=imread(name);
    U1=importdata('U.txt');%读入U1，V1
V1=importdata('V.txt');
I=imread('lena.bmp'); %读入原图
II=im2double(I);  %转化为[0,1)double型  %II为原图像
[m,n]=size(II);  %原图像大小
[U,S,V]=svd(II);  %对原图进行奇异值分解
name=['D:\大三上\数字内容安全\project\jpeg\',num2str(z),'lena_watermark.jpg'];
CWI=imread(name);
CWI=im2double(CWI);
[UU,S1,VV]=svd(CWI); %对含有水印的图像进行奇异值分解
af=0.1; %强度
%NCWI=zeros(size(CWI));
AA=randn(size(CWI));
%[U1,SS,V1]=svd(II); %再进行奇异值分解
SN=U1*S1*V1';  %计算中间矩阵
%%加噪处理
% NCWI=CWI+AA*0.01;  %对含水印的图像加噪声
% [UU,S2,VV]=svd(NCWI); %对含有水印的图像进行奇异值分解
% SN=U2*S2*V2';  %计算中间矩阵
WN=(SN-S)/af;  %提取水印

M=imread('watermark.bmp');  %读入水印图像
W=im2double(M);  %转化为[0,1)double型
[m1,n1]=size(W);
WNN=zeros(m1,n1);
for i=1:m1
    for j=1:n1
        WNN(i,j)=WN(i,j);
    end
end
    NC=corrcoef(W,WNN);
    nc(z)=NC(1,2);
    name=['D:\大三上\数字内容安全\project\jpeg\',num2str(z),'watermark.bmp'];
    imwrite(WNN,name);
end
x=1:100;
plot(x,nc);
title('压缩质量因子~相关系数曲线');
xlabel('含密图像压缩比');
ylabel('相关系数');
