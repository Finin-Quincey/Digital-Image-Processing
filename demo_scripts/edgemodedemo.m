%% Edge mode demonstration
figure("Name", "Edge Mode Demo");
tiledlayout("flow", "TileSpacing", "none");

img = double(imread("rice.png")); % This particular image is a good edge mode demo

% Identity filter does nothing so we can see the pre-processed image
window = identity(15);

%% Display original image
nexttile;
imshow(uint8(img));
title("Original Image");

%% These two only slide the window within the image, black then pads it to the original size

% Discard (crop) edges
nexttile;
imshow(uint8(linearfilter(img, window, "discard")));
title("Edge mode: discard");

% Pad with black
nexttile;
imshow(uint8(linearfilter(img, window, "black")));
title("Edge mode: black");

%% These three add extra pixels around the image before filtering

% Extend edge pixel values outwards
nexttile;
[~, newImg] = linearfilter(img, window, "extend");
imshow(uint8(newImg));
title("Edge mode: extend");

% Wrap pixels from opposite side
nexttile;
[~, newImg] = linearfilter(img, window, "wrap");
imshow(uint8(newImg));
title("Edge mode: wrap");

% Reflect pixels about the boundaries
nexttile;
[~, newImg] = linearfilter(img, window, "reflect");
imshow(uint8(newImg));
title("Edge mode: reflect");