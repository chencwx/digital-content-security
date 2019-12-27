%准确性---容量性能测试代码%%
clc;
clear; 
close all;
k=1;
for z=1:51
    name=[num2str(k),'U.txt'];
U1=importdata(name);%读入U1，V1
name=[num2str(k),'V.txt'];
V1=importdata(name);
I=imread('lena.bmp'); %读入原图
II=im2double(I);  %转化为[0,1)double型  %II为原图像
[m,n]=size(II);  %原图像大小
[U,S,V]=svd(II);  %对原图进行奇异值分解
str=num2str(k);
str=['D:\大三上\数字内容安全\project\encode\',str];
name=[str,'lena_watermark.bmp'];
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
WN=zeros(m,n);
WN=(SN-S)/af;  %提取水印
name=['D:\大三上\数字内容安全\project\嵌入水印(1)\嵌入水印',num2str(k+63),'.bmp'];
M=imread(name);  %读入水印图像
W=im2double(M);  %转化为[0,1)double型
[m1,n1]=size(W);
WNN=zeros(m1,n1);
for i=1:m1
    for j=1:n1
        WNN(i,j)=WN(i,j);
    end
end
k=k+1;
% subplot(2,2,3);imshow(W); title('原始的水印');
% subplot(2,2,4);imshow(WNN); title('提取的水印');
NC=corrcoef(W,WNN);
nc(k)=NC(1,2);
str=num2str(k);
str=['D:\大三上\数字内容安全\project\decode\',str];
name=[str,'lena_watermark.bmp'];
imwrite(WNN,name);
%fprintf('原始水印和提取水印的相关系数:%5.4f\n',nc(k));
% subplot(2,2,1); imshow(II); title('原图像');  %显示原图像
% subplot(2,2,2);  imshow(CWI); title('嵌入了水印后图像');%显示嵌入了水印后图像
end
x(1)=64;
for i =2:52
    x(i)=x(i-1)+1;
end

plot(x,nc);
title('准确性~容量曲线');
xlabel('嵌入水印图片大小');
ylabel('准确率');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%