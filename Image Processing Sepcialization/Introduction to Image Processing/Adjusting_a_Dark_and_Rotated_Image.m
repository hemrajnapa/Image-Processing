img = imread("boston night.JPG");
gray_img = rgb2gray(img);
adjusted_img = imadjust(gray_img, [], [], 0.5);
rotated_img = imrotate(adjusted_img, -1, "crop");
final_img = im2uint8(rotated_img);
imshow(final_img);
