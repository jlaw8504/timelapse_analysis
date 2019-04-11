function [ ensemble_mean, ensemble_var, ratios, means, variances ]...
    = timelapse_signal( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    major_axes = data_cell(2:end,2);
    spindle_lengths = data_cell(2:end,6);
    %find the empty cells in spindle lengths
    spindle_lengths_empty = cellfun(@isempty,spindle_lengths);
    major_axes_empty = cellfun(@isempty,major_axes);
    if max(spindle_lengths_empty) == 1 || max(major_axes_empty) == 1
        %remove the empty rows from major_axes and spindle_lengths
        total_empty = spindle_lengths_empty + major_axes_empty;
        major_axes = major_axes(total_empty==0);
        spindle_lengths = spindle_lengths(total_empty==0);
    end
    %Calc ratio of signal length to spindle length
    ratio = cellfun(@rdivide,major_axes,spindle_lengths);
    ratios{n} = ratio;
    means(n) = mean(ratio);
    variances(n) = var(ratio);
end

ensemble_mean = mean(means);
ensemble_var = mean(variances);

end