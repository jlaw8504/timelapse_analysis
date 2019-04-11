function [ changes_spindles ] = timelapse_signal_changes_vs_spindle_infocus( directory,...
    plane_distance, strain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%instaniate variable
changes_spindles = [];
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    major_axes = data_cell(2:end,2);
    spindle_lengths = data_cell(2:end,6);
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
    spindle_lengths_empty = cellfun(@isempty,spindle_lengths);
    %convert empty cells and distal spbs to NaNs in major axes and spindle
    major_axes(major_axes_empty | spb_distal | spindle_lengths_empty)={nan};
    spindle_lengths(major_axes_empty | spb_distal | spindle_lengths_empty) = {nan};
    %convert the cell arrays to matrices
    major_axes_mat = cell2mat(major_axes);
    spindle_lengths_mat = cell2mat(spindle_lengths);
    %calculate the change in signal length
    length_changes = diff(major_axes_mat);
    %remove the first entry in the spindle_lengths_mat to compare the
    %length changes to the final spindle length
    spindle_lengths_mat = spindle_lengths_mat(1:(end-1),:);
    %horzcat the signal length changes and the spindle lengths
    change_spindle_mat = [length_changes,spindle_lengths_mat];
    changes_spindles = [changes_spindles;change_spindle_mat];

   
end
figure;
scatter(changes_spindles(:,2),changes_spindles(:,1));
xlabel('Initial Spindle Length (nm)');
ylabel('Change per Timestep (nm)');
title(strain);
end