% ��ʴ�����ľ��ʵ�ֺ�Ƶ��ʵ�� we apply convolution and freqency multiplication to 
% obtain the erosion results
% Linyi University
clc
clear all
close all
format long
a_bit=imread('Fig0914.tif');

figure;imshow(a_bit)
a_bit_double=double(a_bit);
r=5;
kernal = strel('diamond',r).Neighborhood;


%ֱ��ʵ��
a_erode=imerode(a_bit,kernal);
figure;imshow(a_erode)
imwrite(a_erode,'Fig0914_erode.png')

%��ʴ�����ı߽����ԣ����нṹԪ��ͼ��߽磬�ҽ���ͼ���ڽṹԪ������Ŀ��ֵ��
% ����ô˲��ԡ�
[m,n]=size(kernal);
[M,N]=size(a_bit);
T=zeros(M,N);
for i = 1:M
    for j = 1:N
        ii_min=max(m-i-(m-1)/2+1,1);
        jj_min=max(n-j-(n-1)/2+1,1);
        ii_max=min(M-i+1+(m-1)/2,m);
        jj_max=min(N-j+1+(n-1)/2,n);
        temp=kernal(ii_min:ii_max,jj_min:jj_max);
        T(i,j)=max(sum(temp(:))-0.0001);
    end
end
        
% ���ʵ�� convolution
conv_result=conv2(a_bit_double,kernal,'same');
conv_result_bit=(conv_result>=T);
figure;imshow(conv_result_bit)
dd=conv_result_bit-a_erode;
%��Ϊ0��˵������ʵ�ַ����Ľ��һ��
dd0=max(dd(:))
dd00=min(dd(:))

%�������Ƶ��ʵ��,pad��ʽ
zerospadimage=zeros(size(a_bit)+size(kernal)-1);
a_bit_double_pad=zerospadimage;
a_bit_double_pad(1:size(a_bit,1),1:size(a_bit,2))=a_bit_double;
kernal_pad=zerospadimage;
kernal_pad(1:size(kernal,1),1:size(kernal,2))=kernal;
a_bit_double_pad_fft=fft2(a_bit_double_pad);
kernal_pad_fft=fft2(kernal_pad);
conv_resul_fft=a_bit_double_pad_fft.*kernal_pad_fft;
conv_resul_ifft=abs(ifft2(conv_resul_fft));
conv_resul_ifft_same=conv_resul_ifft(1+(size(kernal,1)-1)/2:size(a_bit,1)+(size(kernal,1)-1)/2,1+(size(kernal,2)-1)/2:size(a_bit,2)+(size(kernal,2)-1)/2);
conv_resul_ifft_bit_same=(conv_resul_ifft_same>=T);%�����͵���������ȡ0
% conv_resul_ifft_bit_same=conv_resul_ifft_bit(1+(size(kernal,1)-1)/2:size(a_bit,1)+(size(kernal,1)-1)/2,1+(size(kernal,2)-1)/2:size(a_bit,2)+(size(kernal,2)-1)/2);
figure;imshow(conv_resul_ifft_bit_same)
dd=conv_resul_ifft_bit_same-a_erode;

%��Ϊ0��˵������ʵ�ַ����Ľ��һ��
dd1=max(dd(:))
dd2=min(dd(:))

