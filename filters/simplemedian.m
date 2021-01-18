function v = simplemedian(neighbourhood)
%SIMPLEMEDIAN Median filter (basic, inefficient implementation)
%   Performs a simple (inefficient) median filtering operation, for use as
%   a function handle input for the filterimage function.

% This is pretty trivial but I've made it a separate function for
% consistency
v = median(neighbourhood, 'all', 'omitnan');

end