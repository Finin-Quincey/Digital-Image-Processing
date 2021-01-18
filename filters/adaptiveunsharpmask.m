function v = adaptiveunsharpmask(neighbourhood, s)
%ADAPTIVEUNSHARPMASK Adaptive unsharp mask filter
%   Performs an adaptive unsharp masking operation based on the
%   signal-to-noise ratio, for use as a function handle input for the
%   filterimage function. s determines how sensitive the filter is to the
%   SNR.

avg = mean(neighbourhood, 'all', 'omitnan');
stdev = std(neighbourhood, 0, 'all', 'omitnan');
d = ceil(size(neighbourhood) / 2);
snr = avg/stdev;
v = avg + s/snr .* (neighbourhood(d(1), d(2)) - avg);

end