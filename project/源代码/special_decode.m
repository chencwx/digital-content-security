%��ȡˮӡ
%��ˮӡ�ļ������У������������U1��S��V1 �Ϳ�����CWI��ˮӡͼ����ôͨ���򵥵�����̾Ϳ�����ȡ�������Ѿ�ʧ���ˮӡ ������
%1) �����𻵵�ˮӡͼ���������ֵ�ֽ�
%2) �����м����
%3) ���ˮӡͼ��

clc;
clear; 
close all;
U1=importdata('U.txt');%����U1��V1
V1=importdata('V.txt');
I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
[U,S,V]=svd(II);  %��ԭͼ��������ֵ�ֽ�
CWI=imread('lena_watermark.bmp');

%%ֱ��ͼ���⻯
% CWI=histeq(CWI);  %ֱ��ͼ���⻯
%%ֱ��ͼ���⻯


CWI=im2double(CWI);
[UU,S1,VV]=svd(CWI); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
af=0.1; %ǿ��
%NCWI=zeros(size(CWI));

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
subplot(2,2,3);imshow(W); title('ԭʼ��ˮӡ');
subplot(2,2,4);imshow(WNN); title('��ȡ��ˮӡ');
NC=corrcoef(W,WNN);
nc=NC(1,2);
fprintf('ԭʼˮӡ����ȡˮӡ�����ϵ��:%5.4f\n',nc);
subplot(2,2,1); imshow(II); title('ԭͼ��');  %��ʾԭͼ��
subplot(2,2,2);  imshow(CWI); title('Ƕ����ˮӡ��ͼ��');%��ʾǶ����ˮӡ��ͼ��
psnr=imPSNR(II,CWI);
disp("��ͼƬ��PSNRֵΪ:");
disp(psnr);






%%��˹��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PSNR_GAOSI=zeros(50);
% x=zeros(50);
% Relate_GAOSI=zeros(50);
% for i=1:50
% a=i/100;
% imNois1 = imnoise(CWI,'gaussian',0,a);%��ͬ��ǿ��
% imNois1=im2double(imNois1);
% %figure(1),subplot(1,3,2),imshow(imNois1),title('��˹��������');
% %imwrite(imNois1,'��˹��������.bmp');
% PSNR_GAOSI(i)=imPSNR(imNois1,II);
% x(i)=i;
% [Ui,Si,Vi]=svd(imNois1); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% af=0.1; %ǿ��
% %NCWI=zeros(size(CWI));
% AA=randn(size(imNois1));
% SN=U1*Si*V1';  %�����м����
% WN_g=(SN-S)/af;  %��ȡˮӡ
% WNN_g=zeros(m1,n1);
% for k=1:m1
%     for j=1:n1
%         WNN_g(k,j)=WN_g(k,j);
%     end
% end
% NC=corrcoef(W,WNN_g);
% Relate_GAOSI(i)=NC(1,2);%�������ϵ��
% 
% end
% 
% figure;
% subplot(1,2,1); plot(x,PSNR_GAOSI); title('��˹������PSNR�Ĺ�ϵ');xlabel('��˹���ų̶�');ylabel('PSNR');  %��ʾԭͼ��
% subplot(1,2,2);  plot(x,Relate_GAOSI); title('��˹���������ϵ���Ĺ�ϵ');xlabel('��˹���ų̶�');ylabel('���ϵ��');%��ʾǶ����ˮӡ��ͼ��
% %%%%%%��˹���Ų���%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% 
% 
% 
% %%%%��ֵ�˲�%%%%%%%%%%%%%%%%%%%%%%%
% PSNR_LB=zeros(50);
% x=zeros(50);
% Relate_LB=zeros(50);
% for i=1:50
% a=i*i;
% imNois11 = imfilter(CWI,ones(i,i)/a);
% imNois11=im2double(imNois11);
% PSNR_LB(i)=imPSNR(imNois11,II);
% x(i)=i;
% [Uii,Sii,Vii]=svd(imNois11); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% af=0.1; %ǿ��
% %NCWI=zeros(size(CWI));
% AA=randn(size(imNois11));
% SNi=U1*Sii*V1';  %�����м����
% WN_l=(SNi-S)/af;  %��ȡˮӡ
% WNN_l=zeros(m1,n1);
% for k=1:m1
%     for j=1:n1
%         WNN_l(k,j)=WN_l(k,j);
%     end
% end
% NC=corrcoef(W,WNN_l);
% Relate_LB(i)=NC(1,2);%�������ϵ��
% 
% end
% 
% figure;
% subplot(1,2,1); plot(x,PSNR_LB); title('��ֵ�˲���PSNR�Ĺ�ϵ');xlabel('��ֵ�˲��̶�');ylabel('PSNR');  %��ʾԭͼ��
% subplot(1,2,2);  plot(x,Relate_LB); title('��ֵ�˲������ϵ���Ĺ�ϵ');xlabel('��ֵ�˲��̶�');ylabel('���ϵ��');%��ʾǶ����ˮӡ��ͼ��
% %%%%%��ֵ�˲�
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%%%%%��ӽ�������
% PSNR_Z=zeros(50);
% x=zeros(50);
% Relate_ZLB=zeros(50);
% for i=1:50
%   nu=i/100;
% imNois22 = imnoise(CWI,'salt',nu);
% imNois22=im2double(imNois22);
% PSNR_Z(i)=imPSNR(imNois22,II);
% x(i)=i;
% [Uiii,Siii,Viii]=svd(imNois22); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% af=0.1; %ǿ��
% %NCWI=zeros(size(CWI));
% AA=randn(size(imNois22));
% SNi=U1*Siii*V1';  %�����м����
% WN_z=(SNi-S)/af;  %��ȡˮӡ
% WNN_z=zeros(m1,n1);
% for k=1:m1
%     for j=1:n1
%         WNN_z(k,j)=WN_z(k,j);
%     end
% end
% NC=corrcoef(W,WNN_z);
% Relate_ZLB(i)=NC(1,2);%�������ϵ��
%     
% end
% 
% figure;
% subplot(1,2,1); plot(x,PSNR_Z); title('����������PSNR�Ĺ�ϵ');xlabel('���������̶�');ylabel('PSNR');  %��ʾԭͼ��
% subplot(1,2,2);  plot(x,Relate_ZLB); title('�������������ϵ���Ĺ�ϵ');xlabel('���������̶�');ylabel('���ϵ��');%��ʾǶ����ˮӡ��ͼ��
% 
% %%%%��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% %%%�������%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% AA=randn(size(CWI));
% 
% % [UU,S2,VV]=svd(NCWI); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% % SN=U2*S2*V2';  %�����м����
% PSNR_S=zeros(50);
% x=zeros(50);
% Relate_S=zeros(50);
% for i=1:50
% 
% num=i/10;
% imNois4 =CWI+AA*num;
% imNois4=im2double(imNois4);
% PSNR_S(i)=imPSNR(imNois4,II);
% x(i)=i;
% [Uiii4,Siii4,Viii4]=svd(imNois4); %�Ժ���ˮӡ��ͼ���������ֵ�ֽ�
% af=0.1; %ǿ��
% %NCWI=zeros(size(CWI));
% AA=randn(size(imNois4));
% SNi=U1*Siii4*V1';  %�����м����
% WN_S=(SNi-S)/af;  %��ȡˮӡ
% WNN_S=zeros(m1,n1);
% for k=1:m1
%     for j=1:n1
%         WNN_S(k,j)=WN_S(k,j);
%     end
% end
% NC=corrcoef(W,WNN_S);
% Relate_S(i)=NC(1,2);%�������ϵ��
%     
% end
% 
% figure;
% subplot(1,2,1); plot(x,PSNR_S); title('��������̶���PSNR�Ĺ�ϵ');xlabel('��������̶�');ylabel('PSNR');  %��ʾԭͼ��
% subplot(1,2,2);  plot(x,Relate_S); title('��������̶������ϵ���Ĺ�ϵ');xlabel('��������̶�');ylabel('���ϵ��');%��ʾǶ����ˮӡ��ͼ��
% %%%%%%%%%%%%%�������%%%%%%%%%%%%%%%%%






%%%����PSNRֵ
function [ PSNR ] = imPSNR( J , I )
%   I is a image with high quality
%   J is a image with noise
%   the function will return the PSNR of the noise image
width = size(I,2);
heigh = size(I,1);
K = (I-J).*(I-J);
PSNR = sum(sum(K,1));%ÿ�н������
PSNR = PSNR / (width * heigh);
PSNR=10*log10(255*255/PSNR);
end