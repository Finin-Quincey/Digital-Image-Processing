function v = linearwindow(neighbourhood, weights)
%LINEARWINDOW Linear filter with arbitrary window function
%   Performs a linear filtering operation using the given array
%   of weights, for use as a function handle input for the filterimage
%   function. This effectively serves as an adapter for using functions in
%   the linear_filters folder with the generalised filterimage function.

% Yet another good reason to use NaNs to define pixels outside the
% neighbourhood: the sum function has built-in support for excluding them
v = sum(neighbourhood .* weights, 'all', 'omitnan');

end