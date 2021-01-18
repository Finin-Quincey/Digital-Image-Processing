%% Edge detection test for various pre-processing filters

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

% Plot setup
figure("Name", "Edge Detector Test");
tiledlayout(4, 4, "TileSpacing", "none", "Padding", "compact");

edgefunc = @(img) edge(img, "Canny");

%% Display original
nexttile;
imshow(uint8(img));
title("Original Image");

nexttile;
edges = edgefunc(img);
imshow(edges);

%% Simple median (inefficient)
nexttile;
se = ones(5);
newImg = filterimage(img, @simplemedian, se, "extend");
imshow(uint8(newImg));
title("Median, 5x5 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Adaptive weighted median
% Precomputing the distance matrix makes it much more efficient
nexttile;
se = ones(5);
d = distancematrix(5);
newImg = filterimage(img, @(nh) awmedian(nh, 100, 60, d), se, "extend");
imshow(uint8(newImg));
title("AW median, 5x5 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Truncated median
nexttile;
se = ones(5);
newImg = filterimage(img, @(nh) truncmedian(nh, 1), se, "extend");
imshow(uint8(newImg));
title("Trunc. median, 1 pass, 5x5 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Symmetric nearest neighbour
nexttile;
se = ones(7);
newImg = filterimage(img, @symmetricnn, se, "extend");
imshow(uint8(newImg));
title("Symmetric NN, 7x7 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Symmetric nearest neighbour x2
nexttile;
se = ones(7);
newImg = filterimage(newImg, @symmetricnn, se, "extend");
imshow(uint8(newImg));
title("Symmetric NN x2, 7x7 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Kuwahara
nexttile;
se = ones(5);
newImg = filterimage(img, @kuwahara, se, "extend");
imshow(uint8(newImg));
title("Kuwahara, 5x5 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);

%% Median + Kuwahara
nexttile;
se1 = ones(5);
se2 = ones(5); % Debatable whether this is better with 3 or 5
newImg = filterimage(img, @simplemedian, se1, "extend");
newImg = filterimage(newImg, @kuwahara, se2, "extend");
imshow(uint8(newImg));
title("Median + Kuwahara, 5x5 square");

nexttile;
edges = edgefunc(newImg);
imshow(edges);