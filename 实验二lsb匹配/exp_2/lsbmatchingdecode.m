img=imread('lena5_watermark.bmp');
str='';
imgg=img';
img_one=imgg(:);%变为一维数组

for i=1:8%获得字符串的长度
    str=[str,num2str(mod(img_one(i),2))];
end
disp(str);
num=bin2dec(str);
disp(num);
chrr=char(num)
water=''
marke=''
cha_num=str2num(chrr)*8+8%根据长度提取信息

for i=9:cha_num%开始提取
    if mod(img_one(i),2)==0%如果像素值为偶数，则值为0 
        water=[water,'0'];
        %disp(water)
        if mod(i,8)==0%当满8位时，生成字符，并到最终结果中
            disp(water)
            marke=[marke,char(bin2dec(water))];
            water=''
        end
    end
        
    if mod(img_one(i),2)==1
         water=[water,'1'];
         if mod(i,8)==0
            disp(water)
            marke=[marke,char(bin2dec(water))];
            water=''
        end
    end
end
disp(water)
disp(marke)

        
