img = imread("toembed_img3.png");
grey_image = rgb2gray(img);
I = imbinarize(grey_image, 0.5);
%figure
%imshow(I);
%title('Input image');
s = size(I);
share1 = zeros(s(1)*2, s(2) * 2);
share2 = zeros(s(1)*2, s(2) * 2);

%processing for black and white pixels
white = [1 0; 1 0; 1 0; 1 0];
black = [0 1; 1 0; 1 0; 0 1];
for i=1:s(1)
    for j=1:s(2)
        if I(i, j) == 1
            share1(2*i - 1, 2*j - 1) = white(1, 1);
            share1(2*i - 1, 2*j) = white(1, 2);
            share1(2*i, 2*j - 1) = white(2, 1);
            share1(2*i, 2*j) = white(2, 2);
            share2(2*i - 1, 2*j - 1) = white(3, 1);
            share2(2*i - 1, 2*j) = white(3, 2);
            share2(2*i, 2*j - 1) = white(4, 1);
            share2(2*i, 2*j) = white(4, 2);
            
        else
            share1(2*i - 1, 2*j - 1) = black(1, 1);
            share1(2*i - 1, 2*j) = black(1, 2);
            share1(2*i, 2*j - 1) = black(2, 1);
            share1(2*i, 2*j) = black(2, 2);
            share2(2*i - 1, 2*j - 1) = black(3, 1);
            share2(2*i - 1, 2*j) = black(3, 2);
            share2(2*i, 2*j - 1) = black(4, 1);
            share2(2*i, 2*j) = black(4, 2);
        end
    end
end
imwrite(share1, 'share1.png');
imwrite(share2, 'share2.png');