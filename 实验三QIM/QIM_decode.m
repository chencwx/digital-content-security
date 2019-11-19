%% 提取水印
% 频域处理
close all;
clear all;
clc;
img_yuan=imread('lena.bmp');
img=imread('lena_test.bmp');%读取嵌入水印的图像
PSNR=zeros(1,50);
I_double=double(img_yuan);
[I_x, I_y] = size(img);
n=I_x*I_y;
imgg=img';
img_one_test=double(imgg(:));%变为一维数组
%计算嵌入不同长度图的PSNR值
for i=1:50
    J1=imread(['lena_watermark',sprintf('%01d',i),'.bmp']);
    J1_double=double(J1);
    D=J1_double-I_double;%PSNR计算公式
    MSE = sum(D(:).*D(:)) / numel(img_yuan); %numel计算数组中的元素个数
    PSNR(i) = 10*log10(255^2 / MSE);
    x(i)=i;
end
 success=[];
for i=1:50%对嵌入的图像进行各方面评价
    J1=imread(['lena_watermark',sprintf('%01d',i),'.bmp']);
    %J1=imread('lena_watermark50.bmp');
    F=J1;
    
    %根据参数加入随机噪声
    %can=i/100;
    %F = imnoise(J1,'speckle',can); %根据参数加入随机噪声
    %加噪以后计算对应的PSNR
    %J1_double=double(F);
    %D=J1_double-I_double;%PSNR计算公式
    %MSE = sum(D(:).*D(:)) / numel(img_yuan); %numel计算数组中的元素个数
    %PSNR(i) = 10*log10(255^2 / MSE);
    
    [I_x, I_y] = size(F);
    n=I_x*I_y;
    imgg=F';
    img_one=double(imgg(:));%变为一维数组
    
    %对图像加入亮度噪声
    %distance=double(i/5);
    %for sj=1:length(img_one)
    %   img_one(sj)=img_one(sj)+distance;
    %end

    origin='';
    leng = '';%提取水印长度
    % 量化器
% Q1从0开始，Q2从d开始，步长为delta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1

for k=1:8
    b1 = norm(img_one(k)-(round((img_one(k)-d)/2/delta)*2*delta+d));                % pdist默认欧氏距离 euclidean
    b2 = norm(img_one(k)-(round((img_one(k)-d-delta)/2/delta)*2*delta+d+delta));
    if b1 < b2
        leng=[leng,'0'];
    else
        leng=[leng,'1'];
    end
end
num=bin2dec(leng);

cha_num=num*8+8;%根据长度提取信息
watermark='';
temp='';
for k=9:cha_num%真正开始提取水印
    b1 = norm(img_one(k)-(round((img_one(k)-d)/2/delta)*2*delta+d));   %Q(+1)            % pdist默认欧氏距离 euclidean
    b2 = norm(img_one(k)-(round((img_one(k)-d-delta)/2/delta)*2*delta+d+delta));%Q(-1)
    if b1 < b2
        temp=[temp,'0'];
        if mod(k,8)==0 %每八位获取一个字符
              watermark=[watermark,char(bin2dec(temp))];
            temp='';
        end
    
    else
        temp=[temp,'1'];
        if mod(k,8)==0
              watermark=[watermark,char(bin2dec(temp))];
            temp='';
        end
    end
end
    
%输入原始嵌入水印，以便正确率的计算
    for j=1:i
       origin=[origin,'a'];
    end
  %origin='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    
    success(i)=0.0;
    success(i)=mystrsim(origin,watermark);%调用正检率函数
            
        
end
figure;
plot(x,PSNR)%画出PSNR图像
xlabel('不同字符串长度（容量）')
%xlabel('不同噪声');
ylabel('PSNR')
title('不同嵌入容量对应图像的PSNR值')
%title('不同噪声对应的图像的PSNR值');
figure;%画出正检率图像
plot(x,success);
xlabel('不同的噪声');
ylabel('正检率');
title('不同噪声的正检率');


% 量化器
% Q1从0开始，Q2从d开始，步长为delta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1

% test提取水印
leng = '';%提取水印长度
for i=1:8
    b1 = norm(img_one_test(i)-(round((img_one_test(i)-d)/2/delta)*2*delta+d));                % pdist默认欧氏距离 euclidean
    b2 = norm(img_one_test(i)-(round((img_one_test(i)-d-delta)/2/delta)*2*delta+d+delta));
    if b1 < b2
        leng=[leng,'0'];
    else
        leng=[leng,'1'];
    end
end
num=bin2dec(leng);

cha_num=num*8+8;%根据长度提取信息
watermark='';
temp='';
for i=9:cha_num%真正开始提取水印
    b1 = norm(img_one_test(i)-(round((img_one_test(i)-d)/2/delta)*2*delta+d));   %Q(+1)            % pdist默认欧氏距离 euclidean
    b2 = norm(img_one_test(i)-(round((img_one_test(i)-d-delta)/2/delta)*2*delta+d+delta));%Q(-1)
    if b1 < b2
        temp=[temp,'0'];
        if mod(i,8)==0 %每八位获取一个字符
              watermark=[watermark,char(bin2dec(temp))];
            temp='';
        end
    
    else
        temp=[temp,'1'];
        if mod(i,8)==0
              watermark=[watermark,char(bin2dec(temp))];
            temp='';
        end
    end
end
    


disp("您所嵌入的水印信息为：")
disp(watermark)
I_double=double(img_yuan);
 J1=img;
 J1_double=double(J1);
 D=J1_double-I_double;%PSNR计算公式
 MSE = sum(D(:).*D(:)) / numel(img); %numel计算数组中的元素个数
 PSNR = 10*log10(255^2 / MSE);
 disp("PSNR为:")
 disp(PSNR)
if PSNR>40
    disp('图像质量极好，非常接近原图')
end
if PSNR <=40
    if PSNR>30
        disp('图像失真肉眼可见但是可以接受')
    end
end

if PSNR <=30
    if PSNR>20
        disp('图像质量差')
    end
end

if PSNR <=20
    disp('图像不可接受')
end
%字符串比较函数（正检率的计算）
function strsim = mystrsim(target,source)  %X为字符串
len1=length(source);
len2=length(target);
d=zeros(len1+1,len2+1);
    for i=2:length(source)+1
        d(i,1)= i;
    end
     for j=2:length(target)+1
         d(1,j)= j;
     end
     for i =2:length(source)+1
        for j = 2:length(target)+1
             if source(i - 1) == target(j - 1)
               d(i,j) = d(i-1,j-1); %不需要编辑操作
             else
                 edIns = d(i,j-1)+1;    %source 插入字符
                 edDel = d(i-1,j)+1;    %source 删除字符
                 edRep = d(i-1,j-1)+1;  %source 替换字符
                 d(i,j)= min(min(edIns, edDel),edRep);
             end
        end
     end
        y=d(length(source)+1,length(target)+1);  %最少操作次数
        strsim=1/(y+1);    %相似度
end
