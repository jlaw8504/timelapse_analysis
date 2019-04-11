function [ ensemble_mean, ensemble_std, ratios, means, stds, correlations ]...
    = timelapse_signal_to_spindle_ratio( directory, threshold )
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
    spindle_lengths = data_cell(2:end,6);
    %find the empty cells in spindle lengths
    spindle_lengths_empty = cellfun(@isempty,spindle_lengths);
    major_axes_empty = cellfun(@isempty,major_axes);
    %remove the empty rows from major_axes and spindle_lengths
    total_empty = spindle_lengths_empty + major_axes_empty;
    major_axes = major_axes(total_empty==0);
    spindle_lengths = spindle_lengths(total_empty==0);
    %apply a spindle length threshold, pick spindles greater than threshold
    thresh_bin = bsxfun(@gt,cell2mat(spindle_lengths),threshold);
    major_axes = major_axes(thresh_bin==1);
    spindle_lengths = spindle_lengths(thresh_bin==1);
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