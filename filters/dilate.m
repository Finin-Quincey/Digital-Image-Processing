function v = dilate(neighbourhood)
%DILATE Dilation filter
%   Performs a dilation operation, for use as a function handle input
%   for the filterimage function.

% This is pretty trivial but I've made it a separate function for
% consistency
v = max(neighbourhood, [], 'all', 'omitnan');

end