function cost = process(CF)
videoObject = VideoReader("smurfi2.wmv");
frames = videoObject.NumFrames;
video = read(videoObject);
k = video(:, :, :, 1);
toembed = rgb2gray(k);
for x = 1: frames
    frame = video(:, :, :, x);
    grayImage = rgb2gray(frame);
    binaryImage = imbinarize(grayImage);
    cf = complexityFactor(binaryImage);
    if cf > CF
        toembed = grayImage;
        %break;
    end
end
[rows, columns] = size(toembed);
%histogram of grayscale image
hist_original = imhist(toembed);
%disp(hist_original);
%finding the maximum value of the intensity
hist_peak=0;
hist_max=0;
for i=1:256
    if hist_original(i) > hist_max
        hist_max = hist_original(i);
        hist_peak = i;
    end
end

%finding the minimum value of the intensity
hist_bottom = 0;
hist_min = hist_max;
for i=1:256
    if hist_original(i) <= hist_min
        hist_min = hist_original(i);
        hist_bottom = i;
    end
end
        
%assigning flag
if(hist_bottom > hist_peak)
    flag = 0;
else
    flag = 1;
end


shifted_image = grayImage;

%shifting left side
if flag == 1
    actual_bottom = hist_bottom - 1 + 1;
    actual_peak = hist_peak - 1 - 1;
    
    for i = 1:rows
        for j = 1:columns
            if shifted_image(i,j)<=actual_peak && shifted_image(i,j)>=actual_bottom
                shifted_image(i,j) = shifted_image(i,j) - 1;
            end
        end
    end
end

%shifting right side
if flag == 0
    actual_bottom = hist_bottom - 1 -1;
    actual_peak = hist_peak - 1 + 1;
    for i = 1:rows
        for j = 1:columns
            if shifted_image(i,j) >= actual_peak && shifted_image(i,j) <= actual_bottom
                shifted_image(i,j) = shifted_image(i,j) + 1;
            end
        end
    end

end

%hist_shift = imhist(shifted_image);   

%the image to be embedded
wmark = imread("share1.png");
%wmark = rgb2gray(wmark);
%wmark = imbinarize(wmark);

%resizing watermark according to the capacity of the sample image
cap = (uint8(sqrt(hist_max))-1);
wmark = imresize(wmark,[cap,cap]);
%imwrite(wmark, 'C:\Users\user\OneDrive\Desktop\Mini Project\code tries\wmark.png');

%watermarking the image
water_image = shifted_image;
f = 0;

if flag == 0
    intensity = hist_peak - 1;
    r=1;
    c=1;
    for i=1:rows
        if f==1
            break;
        end
        
        for j=1:columns
            if f==1
                break;
            end
        
            if water_image(i,j) == intensity
                if wmark(r,c)==1
                    water_image(i,j)=water_image(i,j)+1;
                    c=c+1;
                else
                    water_image(i,j)=water_image(i,j);
                    c=c+1;
                end
                if c>cap
                    r=r+1;
                    c=1;
                end
                if r>cap
                    f=1;
                    break;
                end
            
            end
        end
    end
end

if flag == 1
    intensity = hist_peak - 1;
    r=1;
    c=1;
    for i=1:rows
        if f==1
            break;
        end
        
        for j=1:columns
            if f==1
                break;
            end
        
            if water_image(i,j) == intensity
                if wmark(r,c)==1
                    water_image(i,j)=water_image(i,j)-1;
                    c=c+1;
                else
                    water_image(i,j)=water_image(i,j);
                    c=c+1;
                end
                if c>cap
                    r=r+1;
                    c=1;
                end
                if r>cap
                    f=1;
                    break;
                end
            
            end
        end
    end
end

%hist_embed = imhist(water_image);
%imshow(water_image); % show 1
%% no attack extraction
na = water_image;
return_image = na;
f = 0;
r = 1;
c = 1;
result = zeros(cap,cap);

if flag ==0
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity+2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end

if flag == 1
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity-2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end
%imshow(result); %show 
[peaksnrna, ~] = psnr(double(wmark), double(result));
[~, rna] = biterr(logical(wmark), logical(result));
%% performing median attack
m = medianAttack(water_image);
%retrieve watermark from image
return_image=m;
f = 0;
r = 1;
c = 1;
result = zeros(cap,cap);

if flag ==0
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity+2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end

if flag == 1
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity-2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end
%imshow(result); %show 
%[peaksnrm, ~] = psnr(double(wmark), double(result));
[~, rm] = biterr(logical(wmark), logical(result));
%cost = peaksnr + 40 * r;
%% adding salt and pepper noise
sap = noiseSaltPepper(water_image);
%retrieve watermark from image
return_image=sap;
f = 0;
r = 1;
c = 1;
result = zeros(cap,cap);

if flag ==0
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity+2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end

if flag == 1
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity-2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end
%imshow(result); %show
%[peaksnrsap, ~] = psnr(double(wmark), double(result));
[~, rsap] = biterr(logical(wmark), logical(result));
%% applying average filter
a = averageFilter(water_image);
%retrieve watermark from image
return_image=a;
f = 0;
r = 1;
c = 1;
result = zeros(cap,cap);

if flag ==0
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity+2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end

if flag == 1
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity-2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end
%[peaksnra, ~] = psnr(double(wmark), double(result));
stack_shares;
[~, ra] = biterr(logical(wmark), logical(result));
%% applying sharpen attack
s = sharpenAttack(water_image);
%retrieve watermark from image
return_image=s;
f = 0;
r = 1;
c = 1;
result = zeros(cap,cap);

if flag ==0
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity+2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end

if flag == 1
    for i=1:rows
        if f==1
            break;
        end
    
        for j=1:columns
            if f==1
                break;
            end
        
            if return_image(i,j)== intensity
                result(r,c)=0;
                c=c+1;
            end
            if return_image(i,j)==(intensity-2)
                result(r,c)=1;
                c=c+1;
            end
            if(c>cap)
                r=r+1;
                c=1;
            end
            if(r>cap)
                f=1;
                break;
            end
        end
    end
end
%[peaksnrs, ~] = psnr(double(wmark), double(result));
imwrite(result, 'extracted_wm.png');
stack_shares;
[~, rs] = biterr(logical(wmark), logical(result));

%% calculating total cost
cost = peaksnrna + (50 * (rna + rm + rsap + ra + rs));
end