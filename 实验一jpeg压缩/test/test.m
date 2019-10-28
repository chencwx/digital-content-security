%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ʵ��һ
%��1��ģ������ͼ��jpegѹ��������PSNR~Q����

close all;
clear all;
clc;
I=imread('lena.bmp');%����ͼƬ
imhist(I)
figure;
x=zeros(1,100);
for i=1:100
    imwrite(I,[sprintf('%03d',i),'lena.jpg'],'quality',i);%��ͬ�����������ɲ�ͬ��ͼƬ
    x(i)=i;
end
I_double=double(I);
PSNR=zeros(1,100);
for i=1:100
    J1=imread([sprintf('%03d',i),'lena.jpg']);
    J1_double=double(J1);
    D=J1_double-I_double;%PSNR���㹫ʽ
    MSE = sum(D(:).*D(:)) / numel(I); %numel���������е�Ԫ�ظ���
    PSNR(i) = 10*log10(255^2 / MSE);
end
figure;
plot(x,PSNR);%����PSNRͼ��
xlabel('��������')
ylabel('PSNR')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%��2����ʾѹ��ǰ��ĻҶ�ֱ��ͼ���۲첢���������ڵĲ���

% close all;
% clear all;
% clc;
% J1=imread('lena.bmp');
% imhist(J1);
% xlabel({' ','�Ҷ�ֵ'});
% ylabel('���ظ���');
% figure;
% J2=imread('070lena.jpg');
% imhist(J2);
% xlabel({' ','�Ҷ�ֵ'});
% ylabel('���ظ���');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%### ��3����ȡJPEGͼ���ļ����Լ��������ȡ��x������������dctϵ����
%ģ�ⷴ��������DCT�任���ָ�����ʾ��Ӧ����ͼ�ο飬�۲첢����JPEGѹ��������Ŀ�ЧӦ

% close all;
% clear all;
% clc;
% I=imread('lena.bmp')
% H=512;
% L=512;
% i=0;
% for height=1:H/64%����64*64�ֿ�
%     for length=1:L/64
%         i=i+1;
%         I_block_eight(:,:,i)=I(((height-1)*64+1):((height-1)*64+64),((length-1)*64+1):((length-1)*64+64));%��-->--,��-->--
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
% for height=1:H/64%����64*64�ֿ�
%     for length=1:L/64
%         i=i+1;
%         block_eight(:,:,i)=DCT(((height-1)*64+1):((height-1)*64+64),((length-1)*64+1):((length-1)*64+64));%��-->--,��-->--
%     end
%     
% end
% matrix1=zeros(64,64)
% matrix1=block_eight(:,:,10)%ȡ����ʮ����
% fan_qt=blockproc(matrix1,[8,8],@(block_struct)block_struct.data.*Y_Table);%������
% fun4 = @(block_struct) idct2(block_struct.data);%������������������DCT�任
% I2 = blockproc(fan_qt,[8, 8],fun4);%���ú���
% I3=uint8(I2+128);
% imshow(I3)
% figure;
% distance=I3-origin