clc;
clear; 
close all;
% I=imread('lenacolor.jpg');
% I=rgb2gray(I);
I=imread('lena.bmp'); %����ԭͼ
II=im2double(I);  %ת��Ϊ[0,1)double��  %IIΪԭͼ��
[m,n]=size(II);  %ԭͼ���С
af=0.1;  %Ƕ��ǿ��
[U,S,V]=svd(II);  %��������ֵ�ֽ�
M=imread('watermark.bmp');  %����ˮӡͼ��
W=im2double(M);  %ת��Ϊ[0,1)double��
[m1,n1]=size(W);
WW=zeros(m,n);
%����ˮӡ��Ϣ�ĳ�ʼ������ֵ
for i=1:m1
    for j=1:n1
            WW(i,j)=W(i,j);
    end
end
S1=S+af*WW;%����ˮӡ��ĶԽ���
[U1,SS,V1]=svd(S1); %�ٽ�������ֵ�ֽ�

dlmwrite('U.txt', U1, 'delimiter', '\t','precision', 20,'newline', 'pc')%��20�ľ��ȴ���txt��
dlmwrite('V.txt', V1, 'delimiter', '\t','precision', 20,'newline', 'pc')
CWI=U*SS*V';  %Ƕ��ˮӡ��ͼ��
imwrite(CWI,'lena_watermark.bmp');
%fprintf('ԭʼˮӡ����ȡˮӡ�����ϵ��:%5.4f\n',nc);
subplot(1,2,1); imshow(II); title('ԭͼ��');  %��ʾԭͼ��
subplot(1,2,2);  imshow(CWI); title('Ƕ����ˮӡ��ͼ��');%��ʾǶ����ˮӡ��ͼ��
