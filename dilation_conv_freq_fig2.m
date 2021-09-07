% 膨胀操作的卷积实现和频域实现 we apply convolution and freqency multiplication to 
% obtain the dilation results for figure 2
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


%直接实现
a_dilate=imdilate(a_bit,kernal);
figure;imshow(a_dilate)
imwrite(a_dilate,'Fig0914_dilate.png')

T=0.1;%腐蚀与膨胀操作，取值不同。其他地方代码完全相同，仅仅此处不同。
% 卷积实现 convolution
conv_result=conv2(a_bit_double,kernal,'same');
conv_result_bit=(conv_result>=T);
figure;imshow(conv_result_bit)
dd=conv_result_bit-a_dilate;
%都为0，说明两种实现方法的结果一样
dd0=max(dd(:))
dd00=min(dd(:))

%卷积定理，频域实现,pad方式
zerospadimage=zeros(size(a_bit)+size(kernal)-1);
a_bit_double_pad=zerospadimage;
a_bit_double_pad(1:size(a_bit,1),1:size(a_bit,2))=a_bit_double;
kernal_pad=zerospadimage;
kernal_pad(1:size(kernal,1),1:size(kernal,2))=kernal;
a_bit_double_pad_fft=fft2(a_bit_double_pad);
kernal_pad_fft=fft2(kernal_pad);
conv_resul_fft=a_bit_double_pad_fft.*kernal_pad_fft;
conv_resul_ifft=abs(ifft2(conv_resul_fft));
conv_resul_ifft_bit=(conv_resul_ifft>=T);
conv_resul_ifft_bit_same=conv_resul_ifft_bit(1+(size(kernal,1)-1)/2:size(a_bit,1)+(size(kernal,1)-1)/2,1+(size(kernal,2)-1)/2:size(a_bit,2)+(size(kernal,2)-1)/2);
figure;imshow(conv_resul_ifft_bit_same)
dd=conv_resul_ifft_bit_same-a_dilate;

%都为0，说明两种实现方法的结果一样
dd1=max(dd(:))
dd2=min(dd(:))

