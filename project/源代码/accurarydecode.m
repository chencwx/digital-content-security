%׼ȷ��---�������ܲ��Դ���%%
clc;
clear; 
close all;
k=1;
for z=1:51
    name=[num2str(k),'U.txt'];
U1=importdata(name);%����U1��V1
name=[num2str(k),'V.txt'];
V1=importdata(name);
I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
[U,S,V]=svd(II);  %��ԭͼ��������ֵ�ֽ�
str=num2str(k);
str=['D:\������\�������ݰ�ȫ\project\encode\',str];
name=[str,'lena_watermark.bmp'];
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
WN=zeros(m,n);
WN=(SN-S)/af;  %��ȡˮӡ
name=['D:\������\�������ݰ�ȫ\project\Ƕ��ˮӡ(1)\Ƕ��ˮӡ',num2str(k+63),'.bmp'];
M=imread(name);  %����ˮӡͼ��
W=im2double(M);  %ת��Ϊ[0,1)double��
[m1,n1]=size(W);
WNN=zeros(m1,n1);
for i=1:m1
    for j=1:n1
        WNN(i,j)=WN(i,j);
    end
end
k=k+1;
% subplot(2,2,3);imshow(W); title('ԭʼ��ˮӡ');
% subplot(2,2,4);imshow(WNN); title('��ȡ��ˮӡ');
NC=corrcoef(W,WNN);
nc(k)=NC(1,2);
str=num2str(k);
str=['D:\������\�������ݰ�ȫ\project\decode\',str];
name=[str,'lena_watermark.bmp'];
imwrite(WNN,name);
%fprintf('ԭʼˮӡ����ȡˮӡ�����ϵ��:%5.4f\n',nc(k));
% subplot(2,2,1); imshow(II); title('ԭͼ��');  %��ʾԭͼ��
% subplot(2,2,2);  imshow(CWI); title('Ƕ����ˮӡ��ͼ��');%��ʾǶ����ˮӡ��ͼ��
end
x(1)=64;
for i =2:52
    x(i)=x(i-1)+1;
end

plot(x,nc);
title('׼ȷ��~��������');
xlabel('Ƕ��ˮӡͼƬ��С');
ylabel('׼ȷ��');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%