img=imread('lena5_watermark.bmp');
str='';
imgg=img';
img_one=imgg(:);%��Ϊһά����

for i=1:8%����ַ����ĳ���
    str=[str,num2str(mod(img_one(i),2))];
end
disp(str);
num=bin2dec(str);
disp(num);
chrr=char(num)
water=''
marke=''
cha_num=str2num(chrr)*8+8%���ݳ�����ȡ��Ϣ

for i=9:cha_num%��ʼ��ȡ
    if mod(img_one(i),2)==0%�������ֵΪż������ֵΪ0 
        water=[water,'0'];
        %disp(water)
        if mod(i,8)==0%����8λʱ�������ַ����������ս����
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

        
