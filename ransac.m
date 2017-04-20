function [translation, numInliers] = ransac(sift_d1, sift_d2, keypoints1, keypoints2)

    %% Constants
    % Threshold for finding appropriate feature pairs
    threshold = 0.7;
    % Epsilon for computing inliers
    epsilon = 50;

    %% First find all the matches for descriptors in d1 to d2

    % Compute the SSD between each row in d1 and each row in d2
    ssds = dist2(sift_d1, sift_d2);

    % Get the two smallest distances for each row
    [a, ix] = sort(ssds,2);
    best2dists = a(:,1:2);

    % Initialize the list of 'good' features (by row)
    feature1rows = 1:size(sift_d1,1);

    % Use Lowe's approach for thresholding based on the ratio of the
    % first and second closest neighbors to find the 'good' features
    feature1rows = feature1rows((best2dists(:,1) ./ best2dists(:,2)) < threshold);

    % Create a matching list of tentatively corresponding features
    feature2rows = ix(feature1rows,1);

    % This is a mapping of row indices of features from the first image to
    % row indices of matching features in the second image. For example:
    %
    % Extract the first good feature from the first image
    % feature1 = sift_d1(mapping(1,1), :);
    % Extract the corresponding matching feature in the second image
    % feature2 = sift_d2(mapping(1,2), :);
    mapping = cat(2, feature1rows', feature2rows);


    % Uncomment this to plot the keypoints and the tentatively
    % corresponding features

    figure(1);colormap(gray);
    plot(keypoints1(mapping(:,1),1),keypoints1(mapping(:,1),2),'+g');
    line([keypoints1(mapping(:,1),1);
    keypoints2(mapping(:,2),1)],[keypoints1(mapping(:,1),2);
    keypoints2(mapping(:,2),2)],'color','y'); 



    %%%%%%%%%%%%%% YOUR CODE HERE %%%%%%%%%%%%%%%%

    % Choose a suitable number of iterations.
    T = 10000;

    bestIdx = 0;
    bestInliers = [];

    for t=1:T
        % Remember, we will only handle translations, not full homographies
        %
        % RANSAC:
        %   Loop over T iterations:
        %       - Select ONE feature pair at random
        %       - Compute the exact translation
        %       - Compute the inliers where the square-root of the sum of
        %         squared differences after applying the translation is less
        %         than epsilon (declared above)
        %   Keep the largest set of inliers
        %   Recompute the average translation estimate using all of the inliers
        %
        % TIPS:
        %   1) Read the help pages on randperm (and repmat, if you don't
        %      remember it)
        %   2) You should be able to do this using one for loop over the number
        %      of iterations, but it may be easier to first use loops and
        %      optimize it later
    end

    % This should be a vector where the first value is dy, the translation
    % in the y direction (remember, this is equivalent to rows), and the
    % second value is dx, the translation in the x direction (columns).
    translation = [];

    % This is the total number of inliers for the largest found set of
    % inliers.
    numInliers = 0;