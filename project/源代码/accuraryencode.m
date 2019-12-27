clc;
clear; 
close all;
k=1;
for z=0:50
    I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
af=0.1;  %Ƕ��ǿ��
[U,S,V]=svd(II);  %��������ֵ�ֽ�
name=['D:\������\�������ݰ�ȫ\project\Ƕ��ˮӡ(1)\Ƕ��ˮӡ',num2str(k+63),'.bmp'];
M=imread(name);  %����ˮӡͼ��
W=im2double(M);  %ת��Ϊ[0,1)double��
[m1,n1]=size(W);
WW=zeros(m,n);
for i=1:m1
    for j=1:n1
            WW(i,j)=W(i,j);
    end
end
S1=S+af*WW;%����ˮӡ��ĶԽ���
[U1,SS,V1]=svd(S1); %�ٽ�������ֵ�ֽ�

name=[num2str(k),'U.txt'];
dlmwrite(name, U1, 'delimiter', '\t','precision', 20,'newline', 'pc')%��20�ľ��ȴ���txt��
name=[num2str(k),'V.txt'];
dlmwrite(name, V1, 'delimiter', '\t','precision', 20,'newline', 'pc')
CWI=U*SS*V';  %Ƕ��ˮӡ��ͼ��
str=num2str(k);
k=k+1;
str=['D:\������\�������ݰ�ȫ\project\encode\',str];
name=[str,'lena_watermark.bmp'];
imnois1=imnoise(CWI,'gaussian',0,0.01);
imwrite(imnois1,name);
%fprintf('ԭʼˮӡ����ȡˮӡ�����ϵ��:%5.4f\n',nc);
% subplot(1,2,1); imshow(II); title('ԭͼ��');  %��ʾԭͼ��
% subplot(1,2,2);  imshow(imnois1); title('Ƕ����ˮӡ��ͼ��');%��ʾǶ����ˮӡ��ͼ��
end