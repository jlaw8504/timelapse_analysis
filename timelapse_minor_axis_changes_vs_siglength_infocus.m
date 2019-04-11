function [ changes_lengths ] = timelapse_minor_axis_changes_vs_siglength_infocus( directory,...
    plane_distance, strain)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%instaniate variable
changes_lengths = [];
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    minor_axes = data_cell(2:end,3);
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
    major_axes_empty = cellfun(@isempty,minor_axes);
    %convert empty cells and distal spbs to NaNs in major axes and spindle
    minor_axes(major_axes_empty | spb_distal)={nan};
    %convert the cell arrays to matrices
    major_axes_mat = cell2mat(minor_axes);
    %calculate the change in signal length
    length_changes = diff(major_axes_mat);
    %convert length changes to rate by dividing by 30 s
    length_changes = length_changes/30;
    %remove the first entry in the major_axes_mat to compare the
    %length changes to the final signal length
    major_axes_mat = major_axes_mat(2:end,:);
    %horzcat the signal length changes and the spindle lengths
    change_signal_mat = [length_changes,major_axes_mat];
    changes_lengths = [changes_lengths;change_signal_mat];
   
end
figure;
scatter(changes_lengths(:,2),changes_lengths(:,1));
xlabel('Signal Length (nm)');
ylabel('Rate of Change (nm/s)');
title(strain);
end