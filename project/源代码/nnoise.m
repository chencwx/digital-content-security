clc;
clear; 
close all;
dictionary ='D:\大三上\数字内容安全\project\img\';
sub_dictionary = dir(dictionary);
disp(sub_dictionary);
pname=strings(1,11);
for k=3:13
    pname(1,k-2)=sub_dictionary(k).name;
end
for z=1:11
    U1=importdata('U.txt');%读入U1，V1
V1=importdata('V.txt');
I=imread('lena.bmp'); %读入原图
II=im2double(I);  %转化为[0,1)double型  %II为原图像
[m,n]=size(II);  %原图像大小
[U,S,V]=svd(II);  %对原图进行奇异值分解
name=pname(z);
name=char(name);
CWI=imread(name);
CWI=im2double(CWI);
[UU,S1,VV]=svd(CWI); %对含有水印的图像进行奇异值分解
af=0.1; %强度
%NCWI=zeros(size(CWI));
AA=randn(size(CWI));
%[U1,SS,V1]=svd(II); %再进行奇异值分解
SN=U1*S1*V1';  %计算中间矩阵

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
figure(z);
subplot(2,2,3);imshow(W); title('原始的水印');
subplot(2,2,4);imshow(WNN); title('提取的水印');
NC=corrcoef(W,WNN);
nc=NC(1,2);
fprintf('原始水印和提取水印的相关系数:%5.4f\n',nc);
subplot(2,2,1); imshow(II); title('原图像');  %显示原图像
subplot(2,2,2);  imshow(CWI); title('嵌入了水印后图像');%显示嵌入了水印后图像
end