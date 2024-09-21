testImageIdx = randi([1,3])
testCoinImage = imread("testCoinImage"+testImageIdx+".png");

% Display the original coin image
imshow(testCoinImage);

% Segment the coin from the image
[testcoinMask, MaskedtestCoin] = segmentCoin(testCoinImage);

% Shrink the coin mask
se = strel('disk', 20, 0);  % Create a disk-shaped structuring element
testcoinMask = imfill(testcoinMask, 'holes'); % Fill any holes in the mask
testcoinMask = imerode(testcoinMask, se); % Erode the mask to shrink it

% Apply Gaussian filter to the masked coin image for edge detection
imgFilt = imgaussfilt(MaskedtestCoin, 0.5, ...
    Padding="circular", FilterDomain="frequency", FilterSize=3);

% Detect edges using the Sobel method
faceEdgeMask = edge(imgFilt, "sobel", 0.05, "both");

% Erase the areas outside the shrunken coin mask
faceEdgeMask(~testcoinMask) = false;

% Display the edge mask
imshow(faceEdgeMask);

% Function to segment the coin from the input image
function [testcoinMask, MaskedtestCoin] = segmentCoin(X)
    % Convert the input image to grayscale
    X = im2gray(X);
    
    % Apply a manual threshold to create a binary mask
    testcoinMask = im2gray(X) > 200;

    % Close the mask using morphological operations
    radius = 12; % Set the radius for closing
    decomposition = 4; % Set the decomposition level
    se = strel('disk', radius, decomposition);
    testcoinMask = imclose(testcoinMask, se);

    % Create a masked image where non-coin areas are set to zero
    MaskedtestCoin = X;
    MaskedtestCoin(~testcoinMask) = 0;
end
