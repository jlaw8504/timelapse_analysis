function [ spindle_lengths, collapse_cell ] = timelapse_deltas( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    spindle_length = data_cell(2:end,6);
    %replace the empty cells with NaNs
    spindle_empty = cellfun(@isempty,spindle_length);
    spindle_length(spindle_empty) = {NaN};
    %push spindles to a cell array
    spindle_lengths{n} = cell2mat(spindle_length);
    %normalize the spindle lengths
    spindle_mat = cell2mat(spindle_length);
    max_length = max(spindle_mat);
    norm_spindle = spindle_mat/max_length;
    %test if the spindle collapses
    %define collapse as 20% of max
    collapse_mat = norm_spindle(norm_spindle<=0.2);
    collapse_cell{n} = collapse_mat;
    if isempty(collapse_mat) == 0
        %plot the spindle
        plot(cell2mat(spindle_length));
        axis([0 41 0 5000]);
        hold on;
    end
end


end