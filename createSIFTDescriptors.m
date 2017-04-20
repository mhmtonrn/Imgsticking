function [sift_d1, sift_d2, keypoints1, keypoints2] = createSIFTDescriptors(im1, keypoints1, im2, keypoints2)
%% Calculate the SIFT descriptors at the keypoints provided for the images

    circles = cat(2, keypoints1, repmat(4, [size(keypoints1,1),1]));
    sift_d1 = find_sift(im1, circles, 1.5);
    keypoints1(all(sift_d1==0,2),:) = [];
    sift_d1(all(sift_d1==0,2),:) = [];
    
    circles2 = cat(2, keypoints2, repmat(4, [size(keypoints2,1),1]));
    sift_d2 = find_sift(im2, circles2, 1.5);
    keypoints2(all(sift_d2==0,2),:) = [];
    sift_d2(all(sift_d2==0,2),:) = [];