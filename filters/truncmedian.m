function v = truncmedian(neighbourhood, passes)
%TRUNCMEDIAN Truncated median filter
%   Performs a truncated median operation with the given number of passes,
%   for use as a function handle input for the filterimage function.

% Although we're finding the median more than once, the values only need to
% be sorted once, and since sorting is the expensive bit it's more
% efficient to sort once at the start and just find the middle value each
% time. This means we're not using MATLAB's median function this time.

% Remove NaNs, convert to a row vector and sort the neighbourhood values
values = sort(reshape(neighbourhood(~isnan(neighbourhood)), 1, []));
% Find the median in the sorted values (we're not bothering with halves
% because there should always be an odd number of values)
v = values(ceil(length(values)/2));

% For each pass...
for pass = 1:passes
    
    % Find the range above and below the median
    upperrange = max(values) - v;
    lowerrange = v - min(values);
    
    % Truncate values above or below the threshold (no need to sort again!)
    % It's important to INCLUDE values equal to the threshold (i.e. <= not
    % <) in order to deal with cases where the median and min/max are equal
    if upperrange > lowerrange
        values = values(values <= v + lowerrange);
    else
        values = values(values >= v - upperrange);
    end
    
    % Recalculate the median again with the remaining values
    len = length(values);
    if mod(len, 2) == 0 % This time we might have an even number
        v = mean(values(len/2 : len/2 + 1));
    else
        v = values(ceil(len/2));
    end
    
end

end

