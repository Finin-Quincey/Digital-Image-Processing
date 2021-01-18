%% Demonstration script for the generalised filter functions
% This script shows how most of the different filters can be used, displays
% a side-by-side comparison of all filters with the original image, and
% plots a graph of the run time for each filter.

clear; % Always clear the workspace!
close all;

%% Setup

% Add the relevant subfolders to the MATLAB path
addpath('images');
addpath('linear_windows');
addpath('filters');
addpath('matlabpgm');

% Read the image
%img = double(imread("nzjers1.jpg"));
img = double(imread("foetus.png"));

%img = double(imread("corn.tif", 3));
%img = double(imread("clown.jpg"));
%img = double(imread("cameraman.tif"));
%img = double(imread("saturn.png"));
%img = double(imread("snowflakes.png"));
%img = double(imread("coins.png"));
%img = double(imread("eight.tif"));
%img = double(imread("rice.png"));
%img = double(imread("moon.tif"));

%load mandrill;
%img = X;

% Plot setup
figure("Name", "Image Filter Demo");
tiledlayout("flow", "TileSpacing", "none", "Padding", "compact");

runtimes = [];

%% Display original
nexttile;
imshow(uint8(img));
title("Original Image");

%% Gaussian blur with linear window adapter
% Demonstrates use of the linearwindow adapter to convert the linear
% filters for use with the generalised filtering function
nexttile;
window = meanblur(5);
se = ones(size(window));
tic;
newImg = filterimage(img, @(nh) linearwindow(nh, window), se, "wrap");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Mean Blur, 5x5 square");

%% Gaussian blur with vectorised convolution
% Efficient implementation for comparison
% N.B. By definition, all linear filters have the same performance for a
% given mask size; Gaussian blur is used here as an example
nexttile;
window = gaussianblur(1);
tic;
newImg = linearfilter(img, window, "wrap");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Gaussian Blur, \sigma = 1");

%% Simple median (inefficient)
nexttile;
se = ones(5);
tic;
newImg = filterimage(img, @simplemedian, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Median, 5x5 square");

%% Dilation
% nexttile;
% % You can of course make these using the strel function but for the sake of
% % implementing things myself I'm only using basic MATLAB functions here
% se = [
%     0, 0, 0, 1, 0, 0, 0;
%     0, 1, 1, 1, 1, 1, 0;
%     0, 1, 1, 1, 1, 1, 0;
%     1, 1, 1, 1, 1, 1, 1;
%     0, 1, 1, 1, 1, 1, 0;
%     0, 1, 1, 1, 1, 1, 0;
%     0, 0, 0, 1, 0, 0, 0;
% ];
% tic;
% newImg = filterimage(img, @dilate, se, "reflect");
% runtimes(end+1) = toc;
% imshow(uint8(newImg));
% title("Dilation, 7x7 circle");
% 
% %% Erosion
% nexttile;
% se = [
%     0, 0, 0, 0, 1, 0, 0, 0, 0;
%     0, 0, 0, 1, 1, 1, 0, 0, 0;
%     0, 0, 1, 1, 1, 1, 1, 0, 0;
%     0, 1, 1, 1, 1, 1, 1, 1, 0;
%     1, 1, 1, 1, 1, 1, 1, 1, 1;
%     0, 1, 1, 1, 1, 1, 1, 1, 0;
%     0, 0, 1, 1, 1, 1, 1, 0, 0;
%     0, 0, 0, 1, 1, 1, 0, 0, 0;
%     0, 0, 0, 0, 1, 0, 0, 0, 0;
% ];
% tic;
% newImg = filterimage(img, @erode, se, "wrap");
% runtimes(end+1) = toc;
% imshow(uint8(newImg));
% title("Erosion, 9x9 diamond");

%% Opening (erode then dilate)
nexttile;
se = [
    0, 1, 1, 1, 0;
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 1;
    1, 1, 1, 1, 1;
    0, 1, 1, 1, 0;
];
tic;
newImg = filterimage(img, @erode, se, "extend");
newImg = filterimage(newImg, @dilate, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Opening, 5x5 circle");

%% Closing (dilate then erode)
nexttile;
tic;
newImg = filterimage(img, @dilate, se, "extend");
newImg = filterimage(newImg, @erode, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Closing, 5x5 circle");

% Same again to prove it is idempotent
% nexttile;
% newImg = filterimage(newImg, @dilate, se, "extend");
% newImg = filterimage(newImg, @erode, se, "extend");
% imshow(uint8(newImg));
% title("Closing, 5x5 circle");

%% Inefficient adaptive weighted median
% This filter is actually pretty decent, but it's very slow!
% nexttile;
% se = ones(5);
% tic;
% newImg = filterimage(img, @(nh) awmedian_inefficient(nh, 100, 60), se, "reflect");
% runtimes(end+1) = toc;
% imshow(uint8(newImg));
% title("Inefficient AW median, 5x5 square");

%% Adaptive weighted median
% Precomputing the distance matrix makes it much more efficient
nexttile;
se = ones(5);
tic;
d = distancematrix(5);
newImg = filterimage(img, @(nh) awmedian(nh, 100, 60, d), se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("AW median, 5x5 square");

%% Truncated median
nexttile;
se = ones(5);
tic;
newImg = filterimage(img, @(nh) truncmedian(nh, 1), se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Trunc. median, 1 pass, 5x5 square");

%% Adaptive unsharp mask
% Unfortunately this didn't seem to work properly :(

% nexttile;
% se = ones(5);
% tic;
% newImg = filterimage(img, @(nh) adaptiveunsharpmask(nh, 0.6), se, "extend");
% runtimes(end+1) = toc;
% imshow(uint8(newImg));
% title("Adaptive UM, s = 0.6, 5x5 square");

%% Symmetric nearest neighbour
nexttile;
se = ones(7);
tic;
newImg = filterimage(img, @symmetricnn, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Symmetric NN, 7x7 square");

%% Symmetric nearest neighbour x2
nexttile;
se = ones(7);
newImg = filterimage(newImg, @symmetricnn, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Symmetric NN x2, 7x7 square");

%% Kuwahara
nexttile;
se = ones(5);
tic;
newImg = filterimage(img, @kuwahara, se, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Kuwahara, 5x5 square");

%% Median + Kuwahara
nexttile;
se1 = ones(5);
se2 = ones(5); % Debatable whether this is better with 3 or 5
tic;
newImg = filterimage(img, @simplemedian, se1, "extend");
newImg = filterimage(newImg, @kuwahara, se2, "extend");
runtimes(end+1) = toc;
imshow(uint8(newImg));
title("Median + Kuwahara, 5x5 square");

%% Run time graph
figure;
titles = {'Gaussian blur', 'Efficient Gaussian blur', 'Simple median', 'Dilation', 'Erosion', 'Opening', 'Closing', 'AW Median', 'Truncated Median', 'Symmetric NN', 'Symmetric NN x2', 'Kuwahara', 'Median + Kuwahara'};
X = categorical(titles);
X = reordercats(X, titles);
bar(X, runtimes);
ylabel("Run time (s)");