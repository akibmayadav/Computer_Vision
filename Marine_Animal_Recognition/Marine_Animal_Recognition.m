%% Object Recoginition (Marine Animal Recognition) 

%% Getting the data set ready 
% Loading all the images 
rootFolder = fullfile('101_ObjectCategories');

% Constructing image sets required for designing a marine animal
% recognition system.
ImageSets = [ imageSet(fullfile(rootFolder, 'crab')), ...
            imageSet(fullfile(rootFolder, 'crayfish')), ...
            imageSet(fullfile(rootFolder, 'dolphin')) , ...
            imageSet(fullfile(rootFolder, 'hawksbill')), ...
            imageSet(fullfile(rootFolder, 'lobster')), ...
            imageSet(fullfile(rootFolder, 'octopus')) , ...
            imageSet(fullfile(rootFolder, 'sea_horse')), ...
            imageSet(fullfile(rootFolder, 'starfish')), ...
            imageSet(fullfile(rootFolder, 'platypus')) ];       

% Segregating or Partioning Image sets into Training and Validation Sets.
SetCount = min([ImageSets.Count]); % determine the smallest amount of images in a category
ImageSets = partition(ImageSets, SetCount, 'randomize');% Use partition method to trim the set.
[trainingSets, validationSets] = partition(ImageSets, 0.3, 'randomize');% Seperating training and validation sets (30%, 70%)

%% Feature Extraction and Classification Scheme using the bagOfFeatures function.
bag = bagOfFeatures(trainingSets);
% Parameters that can be varied here 
% VOCBULARY SIZE (500), STRONGEST FEATURE (0.8),POINTSELECTION (DETECTOR OR GRID), GRIDSTEP([8 8]),BLOCKWIDTH([32 64 96 128])

%% Training the Classifier using the trainImageCatergoryClassfier function .(Multiclass Linear SVM Classifier)
categoryClassifier = trainImageCategoryClassifier(trainingSets, bag);
% (LEARNER OPTIONS - OPT ( written using templateSVM function))
% TEMPLATESVM  : 'BoxConstraint', 1.1, 'KernelFunction', 'gaussian' -- example

%% Calculating or Evaluating the Classifier performance using the evaluate function (gives the confusion matrix)
%  Training Set
confMatrix = evaluate(categoryClassifier, trainingSets);
%  Validation Set
confMatrix = evaluate(categoryClassifier, validationSets);
% Computing accuracy . 
mean(diag(confMatrix));

