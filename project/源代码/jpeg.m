clc;
clear; 
close all;
k=1;
img=imread('lena_watermark.bmp');
for z=1:100
    name=['D:\������\�������ݰ�ȫ\project\jpeg\',num2str(z),'lena_watermark.jpg'];
    imwrite(img,name,'quality',z);
end
for z=1:100
    im=imread(name);
    U1=importdata('U.txt');%����U1��V1
V1=importdata('V.txt');
I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
[U,S,V]=svd(II);  %��ԭͼ��������ֵ�ֽ�
name=['D:\������\�������ݰ�ȫ\project\jpeg\',num2str(z),'lena_watermark.jpg'];
CWI=imread(name);
CWI=im2double(CWI);
[UU,S1,VV]=svd(CWI); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
af=0.1; %ǿ��
%NCWI=zeros(size(CWI));
AA=randn(size(CWI));
%[U1,SS,V1]=svd(II); %�ٽ�������ֵ�ֽ�
SN=U1*S1*V1';  %�����м����
%%���봦��
% NCWI=CWI+AA*0.01;  %�Ժ�ˮӡ��ͼ�������
% [UU,S2,VV]=svd(NCWI); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% SN=U2*S2*V2';  %�����м����
WN=(SN-S)/af;  %��ȡˮӡ

M=imread('watermark.bmp');  %����ˮӡͼ��
W=im2double(M);  %ת��Ϊ[0,1)double��
[m1,n1]=size(W);
WNN=zeros(m1,n1);
for i=1:m1
    for j=1:n1
        WNN(i,j)=WN(i,j);
    end
end
    NC=corrcoef(W,WNN);
    nc(z)=NC(1,2);
    name=['D:\������\�������ݰ�ȫ\project\jpeg\',num2str(z),'watermark.bmp'];
    imwrite(WNN,name);
end
x=1:100;
plot(x,nc);
title('ѹ����������~���ϵ������');
xlabel('����ͼ��ѹ����');
ylabel('���ϵ��');
