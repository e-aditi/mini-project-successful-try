share1 = imread('share1.png');
share2 = imread('share2.png');
s = size(share2);
stacking_shares = zeros(s(1), s(2));
for i=1:s(1)
    for j=1:s(2)
        if(share1(i, j) == 0 || share2(i, j) == 0)
            stacking_shares(i, j) = 0;
        else
            stacking_shares(i, j) = 1;
        end
    end
end