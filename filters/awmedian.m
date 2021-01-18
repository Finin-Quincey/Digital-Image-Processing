function v = awmedian(neighbourhood, W, c, d)
%AWMEDIAN Adaptive weighted median filter
%   Performs an adaptive weighted median operation based on the
%   signal-to-noise ratio, for use as a function handle input for the
%   filterimage function. W is the central weight and c is the distance
%   multiplier.

% This is a more efficient implementation that uses vectorisation rather
% than loops. However, it requires the distance matrix d to be precomputed
% using the function distancematrix.m

if size(neighbourhood) ~= size(d)
    error("Distance matrix does not match window size");
end

% Calculate local statistics
avg = mean(neighbourhood, 'all', 'omitnan');
stdev = std(neighbourhood, 0, 'all', 'omitnan');

% Prevent divide by zero errors (if the average is zero then all the values
% must be zero anyway so just return 0 and be done with)
if avg == 0
    v = 0;
    return;
end

% Calculate weights
% See image enhancement notes, page 36
w = round(W - (c * d * stdev) / avg);
w(w < 0) = 0; % Remove negative values
% Flatten w and neighbourhood into row vectors for repelem to work properly
neighbourhood = reshape(neighbourhood, 1, []);
w = reshape(w, 1, []);
% Construct a list of values where the each value in neighbourhood is
% repeated n times, where n is the corresponding value in w
values = repelem(neighbourhood, w);

% Finally, perform the median operation
v = median(values, 'omitnan');

end