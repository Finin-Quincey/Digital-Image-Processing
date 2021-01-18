%% Mask size comparison script
% Evaluates a filter over a range of square mask sizes

clear; % Always clear the workspace!
close all;

%% Setup

% Add the relevant subfolders to the MATLAB path
addpath('images');
addpath('linear_windows');
addpath('filters');
addpath('matlabpgm');

% Read the image
img = double(imread("nzjers1.jpg"));
%img = double(imread("foetus.png"));

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

% Test parameters
f = {@simplemedian, @kuwahara}; % Filter functions, in order of application
masksizes = [3, 5, 7, 9, 11]; % Mask sizes to test

% Plot setup
figure("Name", "Image Filter Demo");
tiledlayout("flow", "TileSpacing", "none");

runtimes = [];

%% Display original
nexttile;
imshow(uint8(img));
title("Original Image");

%% Display the filter for different mask sizes
for n = masksizes
    nexttile;
    se = ones(n);
    tic;
    d = distancematrix(n);
    newImg = img;
    for m = 1:length(f)
        newImg = filterimage(newImg, f{m}, se, "extend");
    end
    runtimes(end+1) = toc;
    imshow(uint8(newImg));
    title(sprintf("%i x %i mask", n, n));
end

%% Run time graph
figure;
bar(masksizes, runtimes);
xlabel("Mask size");
ylabel("Run time (s)");