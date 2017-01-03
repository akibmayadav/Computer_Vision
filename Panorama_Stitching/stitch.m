function stitch(images)
scene = imageSet(images);
image = read(scene, 1);

% Extract SURFfeatures for the first image
grayImage = rgb2gray(image); %convert to black and white
points = detectSURFFeatures(grayImage); %surf points
[features, points] = extractFeatures(grayImage, points);%features and location indices

%%

H(scene.Count) = projective2d(eye(3)); 
for n = 2:scene.Count

    oldpoints = points;
    oldfeatures = features;

    % Read current image into image
    image = read(scene, n);

    % % Extract surfeatures for the current image
    grayImage = rgb2gray(image);%convert to black and white
    points = detectSURFFeatures(grayImage);%detect SURF points
    [features, points] = extractFeatures(grayImage, points);%extract location and indices

    % Find matching features between current and old image
    indexPairs = matchFeatures(features, oldfeatures, 'Unique', true);

    matchedPoints = points(indexPairs(:,1), :); % extracting the matched points features
    oldmatchedPoints = oldpoints(indexPairs(:,2), :); % extracting the matched points features
    H(n) = estimateGeometricTransform(matchedPoints, oldmatchedPoints,...
        'projective', 'Confidence', 99.9, 'MaxNumTrials', 2000);
    % H(n) = ransac(matchedPoints,oldmatchedPoints,4);
    H(n).T = H(n-1).T * H(n).T;
    
   
end

 %% COMPUTING TRANFORM RELATION TO CENTER IMAGE 
    % As of now the transforms are relative to the first image. We want to
    % make it relative to the center image
imageSize = size(image); 
for i = 1:numel(H)
    [xlim(i,:), ylim(i,:)] = outputLimits(H(i), [1 imageSize(2)], [1 imageSize(1)]);
end  
avgXLim = mean(xlim, 2);
[~, idx] = sort(avgXLim);
centerIdx = floor((numel(H)+1)/2);
centerImageIdx = idx(centerIdx);
Tinv = invert(H(centerImageIdx));
for i = 1:numel(H)
    H(i).T = Tinv.T * H(i).T;
end

%% INITIALISING PANORAMA
for i = 1:numel(H)
    [xlim(i,:), ylim(i,:)] = outputLimits(H(i), [1 imageSize(2)], [1 imageSize(1)]);
end
xMin = min([1; xlim(:)]);
xMax = max([imageSize(2); xlim(:)]);

yMin = min([1; ylim(:)]);
yMax = max([imageSize(1); ylim(:)]);

width  = round(xMax - xMin);
height = round(yMax - yMin);

panorama = zeros([height width 3], 'like', image);

%% Creating the Panorama
blender = vision.AlphaBlender('Operation', 'Binary mask', ...
    'MaskSource', 'Input port');

% Create a 2-D spatial reference object defining the size of the panorama.
xLimits = [xMin xMax];
yLimits = [yMin yMax];
panoramaView = imref2d([height width], xLimits, yLimits);

% Create the panorama.
for i = 1:scene.Count

    image = read(scene, i);

    % Transform I into the panorama.
    warpedImage = imwarp(image, H(i), 'OutputView', panoramaView);

    % Overlay the warpedImage onto the panorama.
    panorama = step(blender, panorama, warpedImage, warpedImage(:,:,1));
end

figure
imshow(panorama)

end
