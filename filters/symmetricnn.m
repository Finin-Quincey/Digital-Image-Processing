function v = symmetricnn(neighbourhood)
%SYMMETRICNN Symmetric nearest-neighbour filter
%   Performs a symmetric nearest-neighbour filtering operation, for use as
%   a function handle input for the filterimage function.

% Convert the neighbourhood to a row vector
values = reshape(neighbourhood, 1, []);
values = values(~isnan(values)); % Remove NaNs (assume they are distributed symmetrically)

% Extract the central pixel value
m = ceil(length(values) / 2);
centre = values(m);

% Chop the rest of the vector in half, reverse the second half and
% concatenate it below the first half so each column is a pair of opposite
% values (this is the 'symmetric' bit)
values = [values(1:m-1); flip(values(m+1:end))];

% Find the indices of the minimum difference in each column (either 1 or 2)
% This is the 'nearest-neighbour' bit
% The 'linear' flag makes it return indices for the entire matrix rather
% than the indices within the columns themselves, for indexing later
[~, idx] = min(abs(values - centre), [], 'linear');

% Retrieve the values at those indices and append the central value
values = [values(idx), centre];

% Finally, calculate the mean of the selected values
v = mean(values);

end