% 像素值为0只能加一，像素值为255只能减一
x=input('please input a string you want:','s');%输入字符串
lenth=length(x);%根据字符串长度嵌入
% disp(lenth);
img=imread('lena.bmp');
imgg=img';
img_one=imgg(:)';%将数组变为一维数组便于嵌字符串

l=num2str(lenth);
% disp(l)
strin=[l,x];
% disp(strin);
strin_bits=str_to_bits(strin)%将字符串转为ASCII码的二进制值
disp(strin_bits)
num=lenth*8+8
for i=1:num
    if strin_bits(i)==0%嵌入值为0 
        r=rand(1,1);%生成随机数
        if mod(img_one(i),2)==0%原始像素值为偶数，则不变
        end
        if mod(img_one(i),2)==1%原始像素值为基数，加一或减一
          if r>0.5%随机值判断
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
img_nn=img_new';%生成新的数组
imwrite(img_nn,'lena5_watermark.bmp');%生成新的图片
    function [msg_bits] = str_to_bits(msgStr)
    
    msgBin = de2bi(int8(msgStr),8,'left-msb');
    len = size(msgBin,1).*size(msgBin,2);
    msg_bits = reshape(double(msgBin).',len,1).';
    
    end  