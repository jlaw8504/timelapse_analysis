function [ length_changes ] = timelapse_signal_changes( directory )
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
    major_axes = data_cell(2:end,2);
    %find the empty cell
    major_axes_empty = cellfun(@isempty,major_axes);
    %convert empty cells to NaNs
    major_axes(major_axes_empty)={nan};
    %convert the cell array to a matrix
    major_axes_mat = cell2mat(major_axes);
    %calculate the change in signal length
    length_changes = [length_changes; diff(major_axes_mat)];

   
end


end