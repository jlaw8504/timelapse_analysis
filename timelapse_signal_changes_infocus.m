function [ length_changes ] = timelapse_signal_changes_infocus( directory,...
    plane_distance)
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
    %% Empty the major axes that have spindles >1 z-plane apart
    %load in the spb information
    spb1 = data_cell(2:end,7);
    spb2 = data_cell(2:end,8);
    %replace empty rows with nans and make planes a thousand apart
    spb1_empty = cellfun(@isempty,spb1);
    spb2_empty = cellfun(@isempty,spb2);
    spb_empty = spb1_empty | spb2_empty;
    %artifically make planes 1000 apart to filter them out later
    spb1(spb_empty) = {[nan,nan,-1000,nan]};
    spb2(spb_empty) = {[nan,nan,1000,nan]};
    %determine diff in planes of spbs
    spb_diff = cellfun(@(x,y) (abs(x(1,3)-y(1,3))),spb1,spb2);
    spb_distal = spb_diff > plane_distance;
    %find the empty cell
    major_axes_empty = cellfun(@isempty,major_axes);
    %convert empty cells and distal spbs to NaNs
    major_axes(major_axes_empty | spb_distal)={nan};
    %convert the cell array to a matrix
    major_axes_mat = cell2mat(major_axes);
    %calculate the change in signal length
    length_changes = [length_changes; diff(major_axes_mat)];

   
end


end