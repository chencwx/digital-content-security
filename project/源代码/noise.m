%%���Ӳ�ͬ�������������ܲ���%%%%%%%%%%%%%%%%%%
clc
clear
close all
im=imread('lena1.bmp');
figure(1),subplot(1,3,1),imshow(im),title('ԭʼͼ��')
imNois1 = imnoise(im,'gaussian',0,0.005);
figure(1),subplot(1,3,2),imshow(imNois1),title('��˹��������')
imwrite(imNois1,'��˹��������.bmp');
imNois2 = imnoise(im,'salt & pepper',0.1);
figure(1),subplot(1,3,3),imshow(imNois2),title('������������')
imwrite(imNois1,'������������.bmp');
%��ֵ�˲���
figure(11),subplot(2,3,1),imshow(imNois1),title('��˹��������')
imNois11 = imfilter(imNois1,ones(3,3)/9);
figure(11),subplot(2,3,2),imshow(imNois11),title('3x3 ��ֵ�˲�')
imwrite(imNois11,'��˹��������3x3��ֵ�˲�.bmp');
imNois11 = imfilter(imNois1,ones(5,5)/25);
figure(11),subplot(2,3,3),imshow(imNois11),title('5x5 ��ֵ�˲�')
imwrite(imNois11,'��˹��������5x5��ֵ�˲�.bmp');
imNois11 = imfilter(imNois1,ones(7,7)/49);
figure(11),subplot(2,3,4),imshow(imNois11),title('7x7 ��ֵ�˲�')
imwrite(imNois11,'��˹��������7x7��ֵ�˲�.bmp');
imNois11 = imfilter(imNois1,ones(9,9)/81);
figure(11),subplot(2,3,5),imshow(imNois11),title('9x9 ��ֵ�˲�')
imwrite(imNois11,'��˹��������9x9��ֵ�˲�.bmp');
H=[1 2 1;2 4 2;1 2 1]/16;
imNois11 = imfilter(imNois1,H);
figure(11),subplot(2,3,6),imshow(imNois11),title('3x3 ��Ȩ��ֵ�˲�')
imwrite(imNois11,'��˹��������3x3��Ȩ��ֵ�˲�.bmp');
% ��ֵ�˲���
figure(22),subplot(2,3,1),imshow(imNois2),title('������������')
imNois22 = uint8(medfilt2(imNois2,[3 3]));
figure(22),subplot(2,3,2),imshow(imNois22),title('3x3 ��ֵ�˲�')
imwrite(imNois22,'������������3x3��ֵ�˲�.bmp');
imNois22 = uint8(medfilt2(imNois2,[5 5]));
figure(22),subplot(2,3,3),imshow(imNois22),title('5x5 ��ֵ�˲�')
imwrite(imNois22,'������������5x5��ֵ�˲�.bmp');
imNois22 = uint8(medfilt2(imNois2,[7 7]));
figure(22),subplot(2,3,4),imshow(imNois22),title('7x7 ��ֵ�˲�')
imwrite(imNois22,'������������7x7��ֵ�˲�.bmp');
imNois22 = imfilter(imNois2,ones(3,3)/9);
figure(22),subplot(2,3,5),imshow(imNois22),title('3x3 ��ֵ�˲�')
imwrite(imNois22,'������������3x3��ֵ�˲�.bmp');
imNois22 = imfilter(imNois2,ones(5,5)/25);
figure(22),subplot(2,3,6),imshow(imNois22),title('5x5 ��ֵ�˲�')
imwrite(imNois22,'������������5x5��ֵ�˲�.bmp');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%