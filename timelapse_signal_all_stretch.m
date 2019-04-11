function [ ensemble_mean, ensemble_var, means_axis, var_axis, major_axes ]...
    = timelapse_signal_all_stretch( directory, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%record current directory to return to at end of program
curr_dir = pwd;
% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    major_axes = data_cell(2:end,2);
    aspect_ratios = data_cell(2:end,4);
    %find the empty cells in spindle lengths
    major_axes_empty = cellfun(@isempty,major_axes);
    if max(major_axes_empty) == 1
        %remove the empty rows from major_axes and spindle_lengths
        total_empty = major_axes_empty;
        major_axes = major_axes(total_empty==0);
        aspect_ratios = aspect_ratios(total_empty==0);
    end
    %% remove foci signals
    %find the foci
    aspect_ratios = cell2mat(aspect_ratios);
    foci_index = aspect_ratios < threshold;
    include = ~foci_index;
    %use logical indexing to remove all foci signals
    major_axes = cell2mat(major_axes);
    major_axes = major_axes(include);
    %Calc mean of major_axis
    means_axis(n) = mean(major_axes,'omitnan');
    var_axis(n) = var(major_axes,'omitnan');
    major_axes_cell{n} = major_axes;
end
%% Calculate ensemble means and variances of major_axis lengths
ensemble_mean = mean(means_axis,'omitnan');
ensemble_var = mean(var_axis,'omitnan');

%% Generate vector of all major axis lengths
major_axes = [];
for i = 1:length(major_axes_cell)
    major_axes = [major_axes; major_axes_cell{i}];
end
cd(curr_dir);
end