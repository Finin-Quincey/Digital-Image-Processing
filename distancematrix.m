function d = distancematrix(S, varargin)
%DISTANCEMATRIX Constructs a distance matrix with the specified size S
%and (optionally) metric ("euclidian", "manhattan" or "chebyshev"). This
%function allows the distances to be precomputed to improve the performance
%of the adaptive weighted median filter awmedian.m.

if nargin > 2
    error("Too many arguments!");
end

metric = "euclidian";

if nargin == 2
    metric = varargin{1};
end

if length(S) == 1
    S = [S, S];
end

% Centre coords
cx = ceil(S(1)/2);
cy = ceil(S(2)/2);

d = zeros(S);

for x = 1:S(1)
    for y = 1:S(2)
        switch metric
            % This is overkill but I've seen it done elsewhere, it looked
            % interesting and is easy enough to implement so I went for it
            case "euclidian"
                d(x, y) = sqrt((x - cx)^2 + (y - cy)^2);
            case "manhattan"
                d(x, y) = abs(x - cx) + abs(y - cy);
            case "chebyshev"
                d(x, y) = max(abs(x - cx), abs(y - cy));
            otherwise
                error("Invalid distance metric!");
        end
    end
end

end