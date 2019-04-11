function [ ensemble_mean, ensemble_std, ratios, means, stds, correlations ]...
    = timelapse_signal_variance( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
counter = 1;
corr_counter = 1;
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    major_axes = data_cell(2:end,2);
    %find the empty cells in major axes
    major_axes_empty = cellfun(@isempty,major_axes);
    %remove the empty rows from major_axes
    major_axes = major_axes(total_empty==0);
    %Calc ratio of signal length to spindle length
    ratio = cellfun(@rdivide,major_axes,spindle_lengths);
    ratios{n} = ratio;
    if length(ratio) > 1
        means(counter) = mean(ratio);
        stds(counter) = std(ratio,1);
        counter = counter + 1;
    end
    %Calc the correlation between signal and spindle length
    if length(major_axes) > 2
        major_axes = cell2mat(major_axes);
        spindle_lengths = cell2mat(spindle_lengths);
        axes_spindle_corr_mat = corrcoef(major_axes,spindle_lengths);
        correlations(corr_counter) = axes_spindle_corr_mat(1,2);
        corr_counter = corr_counter + 1;
    end
end

ensemble_mean = mean(means);
ensemble_std = mean(stds);

end