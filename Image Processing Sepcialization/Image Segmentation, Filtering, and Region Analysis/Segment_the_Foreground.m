testImageIdx = randi([1,3]);
testCoinImage = imread("testCoinImage"+testImageIdx+".png");
figure, imshow(testCoinImage)
title("Original Test Coin Image");

% Segment the coin from the image
[coinMask, testCoinMask] = segmentCoin(testCoinImage);

% Display the segmented mask and original image
montage({testCoinMask, testCoinImage});
title("Segmented Coin and Original Image");

%% Function for Coin Segmentation
function [coinMask, testCoinMask] = segmentCoin(X)
    % Convert input image to grayscale
    X = im2gray(X);

    % Manual thresholding for coin segmentation
    coinMask = X > 188;

    % Close small gaps using morphological closing
    se = strel('disk', 10); % Structuring element with a radius of 10
    coinMask = imclose(coinMask, se);

    % Generate masked image by applying the binary mask to the original image
    testCoinMask = X;
    testCoinMask(~coinMask) = 0;

    % Further refine mask (optional threshold for better visualization)
    testCoinMask = testCoinMask > 100;
end
