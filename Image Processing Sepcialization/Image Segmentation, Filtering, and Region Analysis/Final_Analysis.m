testImageIdx = randi([1,3])
testCoinImage = imread("testCoinImage"+testImageIdx+".png");

% Display the original coin image
imshow(testCoinImage);
title("Original Coin Image");

% Segment the coin from the image
[testcoinMask, MaskedtestCoin] = segmentCoin(testCoinImage);

% Shrink the coin mask
se = strel('disk', 20, 0);
testcoinMask = imfill(testcoinMask, 'holes'); % Fill any holes in the mask
testcoinMask = imerode(testcoinMask, se); % Erode the mask to shrink it

% Apply Gaussian filter and edge detection
imgFilt = imgaussfilt(MaskedtestCoin, 0.5, ...
    Padding="circular", FilterDomain="frequency", FilterSize=3);
faceEdgeMask = edge(imgFilt, "sobel", 0.05, "both");

% Erase areas outside the shrunken coin mask
faceEdgeMask(~testcoinMask) = false;
imshow(faceEdgeMask);
title("Edge Mask Detection for Valid Coins");

% Fill holes and dilate to get the valid coin mask
see = strel("disk", 25, 0);
fb = imfill(faceEdgeMask, "holes");
Bw2 = imdilate(fb, see);
validCoinMask = Bw2 & testcoinMask;

% Further dilate the valid coin mask for better accuracy
set = strel("disk", 2, 0);
validCoinMask = imdilate(validCoinMask, set);
montage({testcoinMask, validCoinMask});
title("testcoinMask vs ValidCoinMask");

% Analyze the size of detected coins
coinSizes = regionprops("table", validCoinMask, "Area");

% Count the number of each coin type based on area
nDimes = sum(coinSizes.Area < 1100);
nNickels = sum(coinSizes.Area > 1100 & coinSizes.Area < 2200);
nQuarters = sum(coinSizes.Area > 2200 & coinSizes.Area < 3200);
nFiftyCents = sum(coinSizes.Area > 3200);

% Calculate the total value of the coins in USD
USD = (nDimes * 0.10) + (nNickels * 0.05) + ...
      (nQuarters * 0.25) + (nFiftyCents * 0.50);

% Display the results
fprintf('Number of Dimes: %d\n', nDimes);
fprintf('Number of Nickels: %d\n', nNickels);
fprintf('Number of Quarters: %d\n', nQuarters);
fprintf('Number of Fifty Cents: %d\n', nFiftyCents);
fprintf('Total USD Value: $%.2f\n', USD);

% Function to segment the coin from the input image
function [testcoinMask, MaskedtestCoin] = segmentCoin(X)
    % Convert the input image to grayscale
    X = im2gray(X);
    
    % Apply a manual threshold to create a binary mask
    testcoinMask = im2gray(X) > 150;

    % Close the mask using morphological operations
    radius = 12; % Set the radius for closing
    decomposition = 4; % Set the decomposition level
    se = strel('disk', radius, decomposition);
    testcoinMask = imclose(testcoinMask, se);

    % Create a masked image where non-coin areas are set to zero
    MaskedtestCoin = X;
    MaskedtestCoin(~testcoinMask) = 0;
end
