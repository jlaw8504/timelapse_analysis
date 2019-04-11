function [ corr_coeff ] = timelapse_changes_correlation( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    %% Load major axis and calculate changes per timestep
    major_axes = data_cell(2:end,2);
    %find the empty cell
    major_axes_empty = cellfun(@isempty,major_axes);
    %convert empty cells to NaNs
    major_axes(major_axes_empty)={nan};
    %convert the cell array to a matrix
    major_axes_mat = cell2mat(major_axes);
    %calculate the change in signal length
    signal_changes{n} = diff(major_axes_mat);
    %% Load spindle lengths and calculate changes per timestep
    spindle_lengths = data_cell(2:end,6);
    %find the empty cell
    spindle_empty = cellfun(@isempty,spindle_lengths);
    %convert empty cells to NaNs
    spindle_lengths(spindle_empty)={nan};
    %convert the cell array to a matrix
    spindle_legnths_mat = cell2mat(spindle_lengths);
    %calculate the change in spindle length
    spindle_changes{n} = diff(spindle_legnths_mat);
end
%% Remove the rows from signal_changes and spindle_changes with NaNs
for n = 1:length(signal_changes)
    isnan_spin = isnan(spindle_changes{n});
    isnan_sig = isnan(signal_changes{n});
    isnan_total = isnan_sig + isnan_spin;
    isnan_total = isnan_total >= 1;
    spindle_changes{n}(isnan_total) = [];
    signal_changes{n}(isnan_total) = [];
    corr_mat = corrcoef(signal_changes{n},spindle_changes{n});
    corr_coeff(n) = corr_mat(1,2);
end