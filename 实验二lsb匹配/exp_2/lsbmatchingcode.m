% ����ֵΪ0ֻ�ܼ�һ������ֵΪ255ֻ�ܼ�һ
x=input('please input a string you want:','s');%�����ַ���
lenth=length(x);%�����ַ�������Ƕ��
% disp(lenth);
img=imread('lena.bmp');
imgg=img';
img_one=imgg(:)';%�������Ϊһά�������Ƕ�ַ���

l=num2str(lenth);
% disp(l)
strin=[l,x];
% disp(strin);
strin_bits=str_to_bits(strin)%���ַ���תΪASCII��Ķ�����ֵ
disp(strin_bits)
num=lenth*8+8
for i=1:num
    if strin_bits(i)==0%Ƕ��ֵΪ0 
        r=rand(1,1);%���������
        if mod(img_one(i),2)==0%ԭʼ����ֵΪż�����򲻱�
        end
        if mod(img_one(i),2)==1%ԭʼ����ֵΪ��������һ���һ
          if r>0.5%���ֵ�ж�
              img_one(i)=img_one(i)-1;
          end
          if r<=0.5
              img_one(i)=img_one(i)+1;
          end
        end
    else
        r=rand(1,1);
        if mod(img_one(i),2)==1
        end
        if mod(img_one(i),2)==0
          if r>0.5
              img_one(i)=img_one(i)-1;
          end
          if r<=0.5
              img_one(i)=img_one(i)+1;
          end
        end
    end
end
img_new=reshape(img_one,512,512);
img_nn=img_new';%�����µ�����
imwrite(img_nn,'lena5_watermark.bmp');%�����µ�ͼƬ
    function [msg_bits] = str_to_bits(msgStr)
    
    msgBin = de2bi(int8(msgStr),8,'left-msb');
    len = size(msgBin,1).*size(msgBin,2);
    msg_bits = reshape(double(msgBin).',len,1).';
    
    end  