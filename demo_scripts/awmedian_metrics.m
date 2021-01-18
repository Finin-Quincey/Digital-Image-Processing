%% Demo of the different metrics for the adaptive weighted median filter

clear;
close all;

img = double(imread("cameraman.tif"));

masksize = 3;
metrics = ["Euclidian", "Manhattan", "Chebyshev"];

figure("Name", "Adaptive Weighted Median Distance Metrics Demo");
tiledlayout("flow", "TileSpacing", "none");

nexttile;
imshow(uint8(img));
title("Original Image");

for n = 1:length(metrics)
    
    d = distancematrix(masksize, lower(metrics(n)));
    newImg = filterimage(img, @(nh) awmedian(nh, 100, 60, d), ones(masksize), "extend");
    
    nexttile;
    imshow(uint8(newImg));
    title(metrics(n));
    
end