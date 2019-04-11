function [radial_displacements, radial_displacements_2d] = timelapse_radial_displacement(directory)
%UNTITLED Summary of this function goes here
%   Calculates the 3D and 2D radial displacements of a directory.  Excludes
%   data in which the plasmid has split or migrated to one pole

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%instaniate variable
radial_displacements = [];
radial_displacements_2d = [];
%loop through the files
for n = 1:length(files)
    %load the data in
    data = load(files(n).name);
    data_cell = data.data_cell;
    %% Process the SPB, plane, and centroid information
    %parse the spindle pole bodies
    spb1 = data_cell(2:end,7);
    spb2 = data_cell(2:end,8);
    %parse the plane informaiton
    planes = data_cell(2:end,1);
    %parse the centroid information
    centroids = data_cell(2:end,5);
    %parse the 3D spindle information, we only want informaiton in cells
    %with spindles
    spindle_length = data_cell(2:end,6);
    %parse the split, we don't want split cells
    split_cell = data_cell(2:end,11);
    %check for empty cells
    split_empty = cellfun(@isempty,split_cell);
    if sum(split_empty) ~= 0
        split_cell(split_empty) = {1};
    end
    split_TF = logical(cell2mat(split_cell));
    %find the empty cells in spbs, planes,spindle length, and centroids
    spb1_empty = cellfun(@isempty,spb1);
    spb2_empty = cellfun(@isempty,spb2);
    spindle_length_empty = cellfun(@isempty,spindle_length);
    centroids_empty = cellfun(@isempty,centroids);
    planes_empty = cellfun(@isempty,planes);
    %use or to combine logical indices and reverse it
    all_empty = spb1_empty | spb2_empty | planes_empty...
        | centroids_empty | split_TF | spindle_length_empty;
    all_full = ~all_empty;
    %index only the full spb entries and centroids
    spb1= spb1(all_full);
    spb2= spb2(all_full);
    centroids = centroids(all_full);
    planes = planes(all_full);
    %convert the pixel coordinates and plane number to nm
    spb1_nm(:,1) = cellfun(@(x) x(1)*64.5,spb1);
    spb1_nm(:,2) = cellfun(@(y) y(2)*64.5,spb1);
    spb1_nm(:,3) = cellfun(@(z) z(3)*300,spb1);
    spb2_nm(:,1) = cellfun(@(x) x(1)*64.5,spb2);
    spb2_nm(:,2) = cellfun(@(y) y(2)*64.5,spb2);
    spb2_nm(:,3) = cellfun(@(z) z(3)*300,spb2);
    centroids_nm(:,1) = cellfun(@(x) x(1)*64.5,centroids);
    centroids_nm(:,2) = cellfun(@(y) y(2)*64.5,centroids);
    centroids_nm(:,3) = cellfun(@(z) z(1)*300,planes);
    %calculate the radial displacements
    %pre-allocate for speed
    radial_displacements_cell = zeros(size(centroids_nm,1),1);
    radial_displacements_cell_2d = zeros(size(centroids_nm,1),1);
    for i = 1:size(centroids_nm,1)
        Q1 = spb1_nm(i,:);
        Q2 = spb2_nm(i,:);
        P = centroids_nm(i,:);
        radial_displacements_cell(i,1) = norm(cross(Q2-Q1,P-Q1))/norm(Q2-Q1);
        radial_displacements_cell_2d(i,1) = abs(det([Q2(:,1:2)-...
            Q1(:,1:2);P(:,1:2)-Q1(:,1:2)]))/norm(Q2(:,1:2)-Q1(:,1:2));
        if isnan(radial_displacements_cell(i,1)) == 1
            display(files(n).name);
        end
    end
    radial_displacements = [radial_displacements;radial_displacements_cell];
    radial_displacements_2d = [radial_displacements_2d;radial_displacements_cell_2d];
    clearvars -except radial_displacements radial_displacements_2d n files
end