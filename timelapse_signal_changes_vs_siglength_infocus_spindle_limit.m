function [ lengthMat, changeMat, normMat ] = timelapse_signal_changes_vs_siglength_infocus_spindle_limit( directory,...
    plane_distance, strain, spindle_limits)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%instaniate variable
lengthMat = [];
changeMat = [];
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
    %Replace empty cells with NaN to ensure they are filtered out later
    spindle_lengths(cellfun(@isempty, spindle_lengths)) = {nan};
    %Get index of spindles withing spindle_limits
    spin_length_idx = cell2mat(spindle_lengths) > spindle_limits(1) & ...
        cell2mat(spindle_lengths) < spindle_limits(2);
    %replace empty rows and out-of-range spindles with nans and make planes a thousand apart
    spb1_empty = cellfun(@isempty,spb1);
    spb2_empty = cellfun(@isempty,spb2);
    spb_empty = spb1_empty | spb2_empty | ~spin_length_idx;
    %artifically make planes 1000 apart to filter them out later
    spb1(spb_empty) = {[nan,nan,-1000,nan]};
    spb2(spb_empty) = {[nan,nan,1000,nan]};
    %determine diff in planes of spbs
    spb_diff = cellfun(@(x,y) (abs(x(1,3)-y(1,3))),spb1,spb2);
    spb_distal = spb_diff > plane_distance;
    %find the empty cell
    major_axes_empty = cellfun(@isempty,major_axes);
    %convert empty cells and distal spbs to NaNs in major axes and spindle
    major_axes(major_axes_empty | spb_distal)={nan};
    %convert the cell arrays to matrices
    major_axes_mat = cell2mat(major_axes);
    %calculate the change in signal length
    length_changes = diff(major_axes_mat);
    %remove the first entry in the major_axes_mat to compare the
    %length changes to the final signal length
    major_axes_mat = major_axes_mat(1:(end-1),:);
    %horzcat the signal length changes and the spindle lengths
    lengthMat = [lengthMat;major_axes_mat];
    changeMat = [changeMat;length_changes];
   
end
%clear nans from lengthMat and changeMat
nan_idx = isnan(lengthMat) | isnan(changeMat);
lengthMat = lengthMat(~nan_idx);
changeMat = changeMat(~nan_idx);
%calculate the percent change matrix
normMat = changeMat./lengthMat * 100;
%split extension and recoil
recoilIdx = changeMat < 0;
extIdx = changeMat >= 0;
recoilChange = changeMat(recoilIdx);
recoilLength = lengthMat(recoilIdx);
recoilNorm = normMat(recoilIdx);
extChange = changeMat(extIdx);
extLength = lengthMat(extIdx);
extNorm = normMat(extIdx);

figure;
hold on;
scatter(extLength(:),extChange(:));
scatter(recoilLength(:),recoilChange(:));
xlabel('Initial Signal Length (nm)');
ylabel('Change per timestep (nm)');
title(strain);
hold off;
figure;
hold on;
scatter(extLength(:),extNorm(:));
scatter(recoilLength(:),recoilNorm(:));
xlabel('Initial Signal Length (nm)');
ylabel('Percent Change');
title(strain);
hold off;

mean_ext = mean(extChange)
mean_recoil = mean(recoilChange)
end