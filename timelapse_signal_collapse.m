function [ aspect_ratios, changes, freq_changes ] = timelapse_signal_collapse( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    aspect_ratio = data_cell(2:end,4);
    %replace the empty cells with NaNs
    aspect_empty = cellfun(@isempty,aspect_ratio);
    aspect_ratio(aspect_empty) = {NaN};
    %push aspect ratios to a cell array
    aspect_ratios{n} = cell2mat(aspect_ratio);
    aspect_ratio_mat = cell2mat(aspect_ratio);
    %define stretch as aspect ratio of > 1.5
    stretch = aspect_ratio_mat > 1.5;
    for i = 1:(size(stretch,1)-1)
        %stretching will equal 1, collapse will be -1
        change(i,1) = stretch(i+1,1) - stretch(i,1);
    end
    %push change into a cell array
    changes{n} = change;
    %calculate the frequency of change
    sum_change = sum(change.^2);
    freq_change = sum_change/size(change,1);
    freq_changes(n) = freq_change;
end