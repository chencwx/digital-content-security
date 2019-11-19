
close all;
clear all;
clc;
x=input('please input a string you want to Steganograph:','s');%�����ַ���
lenth=length(x);%�����ַ�������Ƕ��
img=imread('lena.bmp');
[I_x, I_y] = size(img);
n=I_x*I_y;%ͼ���С
imgg=img';
img_one=double(imgg(:)');%�������Ϊһά�������Ƕ�ַ���
img_cox=[];
strin_bits='';
strin_bits=[lenth,x];%���ַ������Ⱥ��ַ�������������һ��
strin_bits=str_to_bits(strin_bits);%���ַ���תΪASCII��Ķ�����ֵ
w=[]; 
num=lenth*8+8;%����
for i=1:num
    if strin_bits(i)==0
        w(i)=-1;
    else
        w(i)=1;
    end
end
 
% ������
% Q1��0��ʼ��Q2��d��ʼ������Ϊdelta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1
% Ƕ��ˮӡ
for i=1:length(w)
    if w(i)==-1 %��Q(-1)��������
        img_one(i) = round((img_one(i)-d)/2/delta)*2*delta+d;
    else
        img_one(i) = round((img_one(i)-d-delta)/2/delta)*2*delta+d+delta;
    end
end
 
Y = reshape(img_one, [I_x, I_y]);
Y=uint8(Y');
imwrite(Y,'lena_test.bmp');%�����µ�ͼƬ
save_figure = figure();
subplot(1,2,1),imshow(img),title('ԭʼͼ��'),subplot(1,2,2),imshow(Y),title('Ƕ��ˮӡ��');
saveas(save_figure, 'compare.bmp');
%���ַ���תΪ�����ƴ�
 function [msg_bits] = str_to_bits(msgStr);
    
    msgBin = de2bi(int8(msgStr),8,'left-msb');
    len = size(msgBin,1).*size(msgBin,2);
    msg_bits = reshape(double(msgBin).',len,1).';
    
    end  







