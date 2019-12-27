clc;
clear; 
close all;
dictionary ='D:\������\�������ݰ�ȫ\project\img\';
sub_dictionary = dir(dictionary);
disp(sub_dictionary);
pname=strings(1,11);
for k=3:13
    pname(1,k-2)=sub_dictionary(k).name;
end
for z=1:11
    U1=importdata('U.txt');%����U1��V1
V1=importdata('V.txt');
I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
[U,S,V]=svd(II);  %��ԭͼ��������ֵ�ֽ�
name=pname(z);
name=char(name);
CWI=imread(name);
CWI=im2double(CWI);
[UU,S1,VV]=svd(CWI); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
af=0.1; %ǿ��
%NCWI=zeros(size(CWI));
AA=randn(size(CWI));
%[U1,SS,V1]=svd(II); %�ٽ�������ֵ�ֽ�
SN=U1*S1*V1';  %�����м����

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
figure(z);
subplot(2,2,3);imshow(W); title('ԭʼ��ˮӡ');
subplot(2,2,4);imshow(WNN); title('��ȡ��ˮӡ');
NC=corrcoef(W,WNN);
nc=NC(1,2);
fprintf('ԭʼˮӡ����ȡˮӡ�����ϵ��:%5.4f\n',nc);
subplot(2,2,1); imshow(II); title('ԭͼ��');  %��ʾԭͼ��
subplot(2,2,2);  imshow(CWI); title('Ƕ����ˮӡ��ͼ��');%��ʾǶ����ˮӡ��ͼ��
end