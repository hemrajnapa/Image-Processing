% Read in cracks and convert to grayscale
refImg = im2gray(imread("00004.jpg"));
newImg = im2gray(imread("00143.jpg"));
% 1. Determine the reference threshold value from refImg
refThresh = graythresh(refImg);
% 2. Segment the newImg using the reference threshold
newImgBW = im2double(newImg) > refThresh;
% Match newImg's histogram to refImg's histogram
matchedImg = imhistmatch(newImg, refImg);
% Use the reference threshold to segment the histogram-matched crack image
matchImgBW = im2double(matchedImg) > refThresh;
% Display Crack 00143 and both segmentations
montage({newImg, newImgBW, matchImgBW})