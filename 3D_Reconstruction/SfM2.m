%% Assignment 5 
%  2-view, sparse 3D reconstruction algorithm
%  Ambika Yadav
%  References : MATLAB Webpage , MeshLab  

%% STEP 1 : Read a Pair of Images
function SfM2 (a)
imageDir = fullfile(a);
images = imageSet(imageDir);
I1 = read(images, 1);
I2 = read(images, 2);

%% STEP 2 : Feed Camera Parameters 
camParam = [1555.555556,0, 0;
            0 , 1555.555556 , 0;
            800.000000 , 600.000000 , 1] ;
cameraParams=cameraParameters('IntrinsicMatrix',camParam);

%% STEP 3 : Find Matched Points
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', 0.1);
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5); % Creating Point Tracker
imagePoints1 = imagePoints1.Location; %initializing point tracker
initialize(tracker, imagePoints1, I1);
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :); % finding the matched points
matchedPoints2 = imagePoints2(validIdx, :);

%% STEP 4 : Find Fundamental Matrix
[fMatrix, epipolarInliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2, 'Method', 'MSAC', 'NumTrials', 10000);
inlierPoints1 = matchedPoints1(epipolarInliers, :); % epipolar inliners
inlierPoints2 = matchedPoints2(epipolarInliers, :); % epipolar inliners

%% STEP 5 : Computing the Camera Pose
[R, t] = cameraPose(fMatrix, cameraParams, inlierPoints1, inlierPoints2);

%% STEP 6 : 3D Points from Matched points
imagePoints1 = detectMinEigenFeatures(rgb2gray(I1), 'MinQuality', 0.001);
tracker = vision.PointTracker('MaxBidirectionalError', 1, 'NumPyramidLevels', 5);
imagePoints1 = imagePoints1.Location;
initialize(tracker, imagePoints1, I1);
[imagePoints2, validIdx] = step(tracker, I2);
matchedPoints1 = imagePoints1(validIdx, :);
matchedPoints2 = imagePoints2(validIdx, :);

% Camera matrices 
% Camera is at the origin looking along the X-axis. 
% rotation matrix : identity, translation vector : 0.
camMatrix1 = cameraMatrix(cameraParams, eye(3), [0 0 0]);
camMatrix2 = cameraMatrix(cameraParams, R', -t*R');
points3D = triangulate(matchedPoints1, matchedPoints2, camMatrix1, camMatrix2);% Compute the 3-D points
numPixels = size(I1, 1) * size(I1, 2);% Get the color of each reconstructed point
allColors = reshape(I1, [numPixels, 3]);
colorIdx = sub2ind([size(I1, 1), size(I1, 2)], round(matchedPoints1(:,2)),round(matchedPoints1(:, 1)));
color = allColors(colorIdx, :);

% Create the point cloud and store in a ply output file.
ptCloud = pointCloud(points3D, 'Color', color);
out1 = strcat('Output_',a);
pcwrite(ptCloud,out1,'PLYFormat','binary');
end


