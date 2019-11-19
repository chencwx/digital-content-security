%% ��ȡˮӡ
% Ƶ����
close all;
clear all;
clc;
img_yuan=imread('lena.bmp');
img=imread('lena_test.bmp');%��ȡǶ��ˮӡ��ͼ��
PSNR=zeros(1,50);
I_double=double(img_yuan);
[I_x, I_y] = size(img);
n=I_x*I_y;
imgg=img';
img_one_test=double(imgg(:));%��Ϊһά����
%����Ƕ�벻ͬ����ͼ��PSNRֵ
for i=1:50
    J1=imread(['lena_watermark',sprintf('%01d',i),'.bmp']);
    J1_double=double(J1);
    D=J1_double-I_double;%PSNR���㹫ʽ
    MSE = sum(D(:).*D(:)) / numel(img_yuan); %numel���������е�Ԫ�ظ���
    PSNR(i) = 10*log10(255^2 / MSE);
    x(i)=i;
end
 success=[];
for i=1:50%��Ƕ���ͼ����и���������
    J1=imread(['lena_watermark',sprintf('%01d',i),'.bmp']);
    %J1=imread('lena_watermark50.bmp');
    F=J1;
    
    %���ݲ��������������
    %can=i/100;
    %F = imnoise(J1,'speckle',can); %���ݲ��������������
    %�����Ժ�����Ӧ��PSNR
    %J1_double=double(F);
    %D=J1_double-I_double;%PSNR���㹫ʽ
    %MSE = sum(D(:).*D(:)) / numel(img_yuan); %numel���������е�Ԫ�ظ���
    %PSNR(i) = 10*log10(255^2 / MSE);
    
    [I_x, I_y] = size(F);
    n=I_x*I_y;
    imgg=F';
    img_one=double(imgg(:));%��Ϊһά����
    
    %��ͼ�������������
    %distance=double(i/5);
    %for sj=1:length(img_one)
    %   img_one(sj)=img_one(sj)+distance;
    %end

    origin='';
    leng = '';%��ȡˮӡ����
    % ������
% Q1��0��ʼ��Q2��d��ʼ������Ϊdelta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1

for k=1:8
    b1 = norm(img_one(k)-(round((img_one(k)-d)/2/delta)*2*delta+d));                % pdistĬ��ŷ�Ͼ��� euclidean
    b2 = norm(img_one(k)-(round((img_one(k)-d-delta)/2/delta)*2*delta+d+delta));
    if b1 < b2
        leng=[leng,'0'];
    else
        leng=[leng,'1'];
    end
end
num=bin2dec(leng);

cha_num=num*8+8;%���ݳ�����ȡ��Ϣ
watermark='';
temp='';
for k=9:cha_num%������ʼ��ȡˮӡ
    b1 = norm(img_one(k)-(round((img_one(k)-d)/2/delta)*2*delta+d));   %Q(+1)            % pdistĬ��ŷ�Ͼ��� euclidean
    b2 = norm(img_one(k)-(round((img_one(k)-d-delta)/2/delta)*2*delta+d+delta));%Q(-1)
    if b1 < b2
        temp=[temp,'0'];
        if mod(k,8)==0 %ÿ��λ��ȡһ���ַ�
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
    
%����ԭʼǶ��ˮӡ���Ա���ȷ�ʵļ���
    for j=1:i
       origin=[origin,'a'];
    end
  %origin='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa';
    
    success(i)=0.0;
    success(i)=mystrsim(origin,watermark);%���������ʺ���
            
        
end
figure;
plot(x,PSNR)%����PSNRͼ��
xlabel('��ͬ�ַ������ȣ�������')
%xlabel('��ͬ����');
ylabel('PSNR')
title('��ͬǶ��������Ӧͼ���PSNRֵ')
%title('��ͬ������Ӧ��ͼ���PSNRֵ');
figure;%����������ͼ��
plot(x,success);
xlabel('��ͬ������');
ylabel('������');
title('��ͬ������������');


% ������
% Q1��0��ʼ��Q2��d��ʼ������Ϊdelta
d = 5;
delta = 3;
Q1 = 0:2*delta:n; % -1
Q2 = d:2*delta:n; % 1

% test��ȡˮӡ
leng = '';%��ȡˮӡ����
for i=1:8
    b1 = norm(img_one_test(i)-(round((img_one_test(i)-d)/2/delta)*2*delta+d));                % pdistĬ��ŷ�Ͼ��� euclidean
    b2 = norm(img_one_test(i)-(round((img_one_test(i)-d-delta)/2/delta)*2*delta+d+delta));
    if b1 < b2
        leng=[leng,'0'];
    else
        leng=[leng,'1'];
    end
end
num=bin2dec(leng);

cha_num=num*8+8;%���ݳ�����ȡ��Ϣ
watermark='';
temp='';
for i=9:cha_num%������ʼ��ȡˮӡ
    b1 = norm(img_one_test(i)-(round((img_one_test(i)-d)/2/delta)*2*delta+d));   %Q(+1)            % pdistĬ��ŷ�Ͼ��� euclidean
    b2 = norm(img_one_test(i)-(round((img_one_test(i)-d-delta)/2/delta)*2*delta+d+delta));%Q(-1)
    if b1 < b2
        temp=[temp,'0'];
        if mod(i,8)==0 %ÿ��λ��ȡһ���ַ�
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
    


disp("����Ƕ���ˮӡ��ϢΪ��")
disp(watermark)
I_double=double(img_yuan);
 J1=img;
 J1_double=double(J1);
 D=J1_double-I_double;%PSNR���㹫ʽ
 MSE = sum(D(:).*D(:)) / numel(img); %numel���������е�Ԫ�ظ���
 PSNR = 10*log10(255^2 / MSE);
 disp("PSNRΪ:")
 disp(PSNR)
if PSNR>40
    disp('ͼ���������ã��ǳ��ӽ�ԭͼ')
end
if PSNR <=40
    if PSNR>30
        disp('ͼ��ʧ�����ۿɼ����ǿ��Խ���')
    end
end

if PSNR <=30
    if PSNR>20
        disp('ͼ��������')
    end
end

if PSNR <=20
    disp('ͼ�񲻿ɽ���')
end
%�ַ����ȽϺ����������ʵļ��㣩
function strsim = mystrsim(target,source)  %XΪ�ַ���
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
               d(i,j) = d(i-1,j-1); %����Ҫ�༭����
             else
                 edIns = d(i,j-1)+1;    %source �����ַ�
                 edDel = d(i-1,j)+1;    %source ɾ���ַ�
                 edRep = d(i-1,j-1)+1;  %source �滻�ַ�
                 d(i,j)= min(min(edIns, edDel),edRep);
             end
        end
     end
        y=d(length(source)+1,length(target)+1);  %���ٲ�������
        strsim=1/(y+1);    %���ƶ�
end
