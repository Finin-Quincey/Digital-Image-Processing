function v = kuwahara(neighbourhood)
%KUWAHARA Kuwahara filter
%   Performs a kuwahara filtering operation, for use as
%   a function handle input for the filterimage function.

% Get the centre indices
d = ceil(size(neighbourhood) / 2);

% Split the neighbourhood into quadrants and stack them into a 3D matrix
Q = cat(3, ...
    neighbourhood(1:d(1),   1:d(2)  ), ...
    neighbourhood(d(1):end, 1:d(2)  ), ...
    neighbourhood(d(1):end, d(2):end), ...
	neighbourhood(1:d(1),   d(2):end)  ...
);

% Calculate standard deviation for each quadrant
stdev = std(Q, 0, [1, 2], 'omitnan');

% Calculate the mean for the quadrant with the minimum standard deviation
[~, idx] = min(stdev);
v = mean(Q(:, :, idx), 'all', 'omitnan');

end