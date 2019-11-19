
close all;
clear all;
clc;
x=input('please input a string you want to Steganograph:','s');%输入字符串
lenth=length(x);%根据字符串长度嵌入
img=imread('lena.bmp');
[I_x, I_y] = size(img);
n=I_x*I_y;%图像大小
imgg=img';
img_one=double(imgg(:)');%将数组变为一维数组便于嵌字符串
img_cox=[];
strin_bits='';
strin_bits=[lenth,x];%将字符串长度和字符串本身连接在一起
strin_bits=str_to_bits(strin_bits);%将字符串转为ASCII码的二进制值
w=[]; 
num=lenth*8+8;%长度
for i=1:num
    if strin_bits(i)==0
        w(i)=-1;
    else
        w(i)=1;
    end
end
 
% 量化器
% Q1从0开始，Q2从d开始，步长为delta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1
% 嵌入水印
for i=1:length(w)
    if w(i)==-1 %用Q(-1)进行量化
        img_one(i) = round((img_one(i)-d)/2/delta)*2*delta+d;
    else
        img_one(i) = round((img_one(i)-d-delta)/2/delta)*2*delta+d+delta;
    end
end
 
Y = reshape(img_one, [I_x, I_y]);
Y=uint8(Y');
imwrite(Y,'lena_test.bmp');%生成新的图片
save_figure = figure();
subplot(1,2,1),imshow(img),title('原始图像'),subplot(1,2,2),imshow(Y),title('嵌入水印后');
saveas(save_figure, 'compare.bmp');
%将字符串转为二进制串
 function [msg_bits] = str_to_bits(msgStr);
    
    msgBin = de2bi(int8(msgStr),8,'left-msb');
    len = size(msgBin,1).*size(msgBin,2);
    msg_bits = reshape(double(msgBin).',len,1).';
    
    end  







