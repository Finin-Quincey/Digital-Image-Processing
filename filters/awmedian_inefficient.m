function v = awmedian_inefficient(neighbourhood, W, c)
%AWMEDIAN_INEFFICIENT Adaptive weighted median filter (inefficient version)
%   Performs an adaptive weighted median operation based on the
%   signal-to-noise ratio, for use as a function handle input for the
%   filterimage function. W is the central weight and c is the distance
%   multiplier.

% This is the inefficient version, see awmedian.m for a better
% implementation!

% Calculate local statistics
avg = mean(neighbourhood, 'all', 'omitnan');
stdev = std(neighbourhood, 0, 'all', 'omitnan');

% Prevent divide by zero errors (if the average is zero then all the values
% must be zero anyway so just return 0 and be done with)
if avg == 0
    v = 0;
    return;
end

d = size(neighbourhood);

values = [];

% Centre coords
cx = ceil(d(1)/2);
cy = ceil(d(2)/2);

% Calculate weights
for x = 1:d(1)
    for y = 1:d(2)
        % See image enhancement notes, page 36
        w = round(W - (c * sqrt((x - cx)^2 + (y - cy)^2) * stdev) / avg);
        % Add the pixel value at (x, y) to the list w times
        values(end+1:end+w) = ones([w, 1]) * neighbourhood(x, y);
    end
end

% Finally, perform the median operation
v = median(values, 'omitnan');

end