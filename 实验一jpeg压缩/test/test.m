%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%实验一
%（1）模拟数字图形jpeg压缩，绘制PSNR~Q曲线

close all;
clear all;
clc;
I=imread('lena.bmp');%读入图片
imhist(I)
figure;
x=zeros(1,100);
for i=1:100
    imwrite(I,[sprintf('%03d',i),'lena.jpg'],'quality',i);%不同质量因子生成不同的图片
    x(i)=i;
end
I_double=double(I);
PSNR=zeros(1,100);
for i=1:100
    J1=imread([sprintf('%03d',i),'lena.jpg']);
    J1_double=double(J1);
    D=J1_double-I_double;%PSNR计算公式
    MSE = sum(D(:).*D(:)) / numel(I); %numel计算数组中的元素个数
    PSNR(i) = 10*log10(255^2 / MSE);
end
figure;
plot(x,PSNR);%画出PSNR图像
xlabel('质量因子')
ylabel('PSNR')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%（2）显示压缩前后的灰度直方图，观察并分析所存在的差异

% close all;
% clear all;
% clc;
% J1=imread('lena.bmp');
% imhist(J1);
% xlabel({' ','灰度值'});
% ylabel('像素个数');
% figure;
% J2=imread('070lena.jpg');
% imhist(J2);
% xlabel({' ','灰度值'});
% ylabel('像素个数');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%### （3）读取JPEG图像文件，自己编解码提取第x个宏块的量化后dct系数，
%模拟反量化和逆DCT变换，恢复并显示对应空域图形块，观察并分析JPEG压缩所引起的块效应

% close all;
% clear all;
% clc;
% I=imread('lena.bmp')
% H=512;
% L=512;
% i=0;
% for height=1:H/64%进行64*64分块
%     for length=1:L/64
%         i=i+1;
%         I_block_eight(:,:,i)=I(((height-1)*64+1):((height-1)*64+64),((length-1)*64+1):((length-1)*64+64));%行-->--,列-->--
%     end
% end
% origin=I_block_eight(:,:,10)
% imshow(origin)
% figure;
% COVER='050lena.jpg'
% jobj = jpeg_read(COVER); % JPEG image structure
% DCT = jobj.coef_arrays{1,1}; % DCT plane
% Y_Table=jobj.quant_tables{1,1};
% H=512;
% L=512;
% i=0;
% for height=1:H/64%进行64*64分块
%     for length=1:L/64
%         i=i+1;
%         block_eight(:,:,i)=DCT(((height-1)*64+1):((height-1)*64+64),((length-1)*64+1):((length-1)*64+64));%行-->--,列-->--
%     end
%     
% end
% matrix1=zeros(64,64)
% matrix1=block_eight(:,:,10)%取出第十块宏块
% fan_qt=blockproc(matrix1,[8,8],@(block_struct)block_struct.data.*Y_Table);%反量化
% fun4 = @(block_struct) idct2(block_struct.data);%定义句柄函数，进行逆DCT变换
% I2 = blockproc(fan_qt,[8, 8],fun4);%调用函数
% I3=uint8(I2+128);
% imshow(I3)
% figure;
% distance=I3-origin