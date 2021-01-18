function v = erode(neighbourhood)
%ERODE Erosion filter
%   Performs a erosion operation, for use as a function handle input
%   for the filterimage function.

% This is pretty trivial but I've made it a separate function for
% consistency
v = min(neighbourhood, [], 'all', 'omitnan');

end