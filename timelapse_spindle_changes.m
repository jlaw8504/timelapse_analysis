function [ length_changes ] = timelapse_spindle_changes( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%instaniate variable
length_changes = [];
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    spindle_lengths = data_cell(2:end,6);
    %find the empty cell
    major_axes_empty = cellfun(@isempty,spindle_lengths);
    %convert empty cells to NaNs
    spindle_lengths(major_axes_empty)={nan};
    %convert the cell array to a matrix
    spindle_legnths_mat = cell2mat(spindle_lengths);
    %calculate the change in signal length
    length_changes = [length_changes; diff(spindle_legnths_mat)];

   
end


end