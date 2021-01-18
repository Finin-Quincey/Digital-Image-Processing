%% Demonstration script for the linear filter function
% This script demonstrates the function linearfilter.m using a variety of
% different windows (some of which are defined in separate functions in the
% linear_windows folder). This implementation is more efficient than the
% generalised filterimage.m function as it takes advantage of vectorisation
% to reduce the number of loop iterations.

clear; % Always clear the workspace!
close all;

%% Setup

% Add the relevant subfolders to the MATLAB path
addpath('images');
addpath('linear_windows');
addpath('matlabpgm');

% Read the image
img = double(imread("nzjers1.jpg"));

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
figure("Name", "Linear Filter Demo");
tiledlayout("flow", "TileSpacing", "none");

%% Display original
nexttile;
imshow(uint8(img));
title("Original Image");

%% 5x5 mean blur
nexttile;
window = meanblur(5);
newImg = linearfilter(img, window, "black");
imshow(uint8(newImg));
title("5x5 Mean Blur, edge mode = black");

%% Gaussian blur with sigma = 3
nexttile;
window = gaussianblur(3);
newImg = linearfilter(img, window, "wrap");
imshow(uint8(newImg));
title("Gaussian Blur, \sigma = 3, edge mode = wrap");

%% Laplace edge detector (square)
nexttile;
window = -1/3 * [
    -1, -1, -1;
    -1,  8, -1;
    -1, -1, -1
];
newImg = linearfilter(img, window, "reflect");
imshow(uint8(newImg));
title("Laplace Edge Detector (square), edge mode = reflect");

%% Laplace edge detector (cross)
nexttile;
window = [
     0, -1,  0;
    -1,  4, -1;
     0, -1,  0
];
newImg = linearfilter(img, window, "extend");
imshow(uint8(newImg));
title("Laplace Edge Detector (cross), edge mode = extend");

%% Laplacian of gaussian edge detector with sigma = 0.5
nexttile;
window = logedge(0.5);
newImg = linearfilter(img, window, "extend");
imshow(uint8(newImg));
title("LoG Edge Detector, \sigma = 0.5, edge mode = extend");

%% Unsharp mask (constant)
nexttile;
window = unsharpmask(3);
newImg = linearfilter(img, window, "reflect");
imshow(uint8(newImg));
title("Unsharp Mask, edge mode = reflect");

%% The rest of these were just me messing around to see what happens

%% Outline thing?
% nexttile;
% window = [
%      1,  0,  1;
%      0, -3,  0;
%      1,  0,  1
% ];
% % window = 1 * [
% %      2, -1,  2;
% %     -1, -3, -1;
% %      2, -1,  2
% % ];
% newImg = linearfilter(img, window, "extend");
% imshow(uint8(newImg));
% title("Outline thing?, edge mode = extend");

% %% 5x5 Random
% nexttile;
% window = rand(5) * 5 - 2;
% window = window / sum(window); % Normalise
% newImg = linearfilter(img, window, "wrap");
% imshow(uint8(newImg));
% title("Random 5x5, edge mode = wrap");
% 
% %% Stripy thing
% nexttile;
% window = -6.2 * [
%      0, 0, 1, 0, 0, 1, 0, 0, 1;
%      0, 1, 0, 0, 1, 0, 0, 1, 0;
%      1, 0, 0, 1, 0, 0, 1, 0, 0;
%      0, 0, 1, 0, 0, 1, 0, 0, 1;
%      0, 1, 0, 0, 1, 0, 0, 1, 0;
%      1, 0, 0, 1, 0, 0, 1, 0, 0;
%      0, 0, 1, 0, 0, 1, 0, 0, 1;
%      0, 1, 0, 0, 1, 0, 0, 1, 0;
%      1, 0, 0, 1, 0, 0, 1, 0, 0;
% ] + 2;
% newImg = linearfilter(img, window, "wrap");
% imshow(uint8(newImg));
% title("Something, edge mode = wrap");
% 
% %% What even is this
% nexttile;
% window = [
%      1, -1,  1, -1,  1, -1,  1, -1,  1;
%     -1,  1, -1,  1, -1,  1, -1,  1, -1;
%      1, -1,  1, -1,  1, -1,  1, -1,  1;
%     -1,  1, -1,  1, -1,  1, -1,  1, -1;
%      1, -1,  1, -1,  1, -1,  1, -1,  1;
%     -1,  1, -1,  1, -1,  1, -1,  1, -1;
%      1, -1,  1, -1,  1, -1,  1, -1,  1;
%     -1,  1, -1,  1, -1,  1, -1,  1, -1;
%      1, -1,  1, -1,  1, -1,  1, -1,  1;
% ];
% newImg = ifft2(linearfilter(fft2(img), window, "wrap"));
% imshow(uint8(newImg));
% title("Something, edge mode = wrap");