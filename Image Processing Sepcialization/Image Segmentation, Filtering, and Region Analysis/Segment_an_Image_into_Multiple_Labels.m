% Load the puzzle image and display it
img = imread('Puzzle_06.jpg');
imshow(img); title("Original Image");

% Convert to grayscale and segment
imgGray = im2gray(img);
[BW, maskedImage] = segmentImageEx(imgGray);
imshow(BW); title("Binary Masked Image");

% Merge the binary mask with the original image
img(repmat(~BW, 1, 1, 3)) = 0;
imshow(img); title("Merged Image with Background Removed");

% Apply K-means clustering for enhanced segmentation visualization
k = 3; 
labels = imsegkmeans(img, k);
montage({img, label2rgb(labels)}); title("Segmented Image with K-means Clustering");

%% Function for Image Segmentation
function [BW, maskedImage] = segmentImageEx(X)
    % Convert grayscale image to binary using adaptive thresholding
    BW = imbinarize(X, 'adaptive', 'Sensitivity', 0.5, 'ForegroundPolarity', 'bright');
    
    % Perform morphological opening (erosion followed by dilation)
    BW = imopen(BW, strel('disk', 3));
    
    % Dilate the binary image to fill gaps
    BW = imdilate(BW, strel('disk', 2));
    
    % Generate the masked image
    maskedImage = X;
    maskedImage(~BW) = 0;
end
