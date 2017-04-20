%% Load default images if they aren't already loaded
% This loads the default left and right images if the variables 'left' and 
% 'right' are not already in the workspace
if ~exist('left', 'var') || ~exist('right', 'var')
    left = imread('leftCastle.jpg');
    right = imread('rightCastle.jpg');
end

%% Display the left image for debugging
figure(1); imagesc(left); hold on;

%% Find the corner keypoints in the left image
if size(left,3) == 3
    left = rgb2gray(left);
end
keypoints1 = corner(single(left));

%% Find the corner keypoints in the right image
if size(right, 3) == 3
    right = rgb2gray(right);
end
keypoints2 = corner(single(right));

%% Compute the SIFT descriptors at the keypoints
[sift_d1, sift_d2, keypoints1, keypoints2] = createSIFTDescriptors(left, keypoints1, right, keypoints2);

%% Run RANSAC over the SIFT descriptors at the keypoints
[translation, numInliers] = ransac(sift_d1, sift_d2, keypoints1, keypoints2);

hold off;
ranslation = fliplr(-translation);

%% Stitch the two images together based on the computed translation
% First pad the left and right images based on the translation, then stitch
% them together.
comb = cat(3, padarray(left, abs(translation), 'post'), padarray(right, abs(translation), 'pre'));
stitched = sum(comb,3)./sum(comb~=0, 3);

% Save the stitched image as a .mat file that can be loaded into MATLAB or
% Octave for viewing later. For example:
% load stitched_image.mat; imagesc(stitched); colormap(gray);
save('stitched.mat', 'stitched');

% Show the original images, the translated images, and the final stitched
% image
figure(1); colormap(gray);
subplot(3,2,1); imagesc(left);
title('Original left image');
subplot(3,2,2); imagesc(right);
title('Original right image');
subplot(3,2,3); imagesc(comb(:,:,1));
title('Padded left image');
subplot(3,2,4); imagesc(comb(:,:,2));
title('Padded right image');
subplot(3,2,5:6); imagesc(stitched);
title('Full stitched image');
saveas(gcf, 'multiImages', 'pdf');

% And show the final stitched image large for viewing purposes
figure(2);
colormap(gray);
imagesc(stitched);
title('Full stitched image');
saveas(gcf, 'fullStitched', 'pdf');

disp(['Translation found: [', num2str(translation(1)), ', ', num2str(translation(2)), ']']);