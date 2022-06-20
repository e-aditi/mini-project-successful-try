function cf = complexityFactor(bimg)
    [rows, columns] = size(bimg);
    k = 0;
    for i=2:rows
        for j=2:columns
            if(bimg(i, j) ~= bimg(i, j-1))
                k = k+1;
            end
        end
    end
    for i=2:columns
        for j=2:rows
            if(bimg(j, i) ~= bimg(j-1, i))
                k = k+1;
            end
        end
    end
    cf = k/(rows * columns);
end