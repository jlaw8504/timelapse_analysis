function [ kmt_diffs ] = timelapse_kMT_diff( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    kMT_1 = data_cell(2:end,9);
    kMT_2 = data_cell(2:end,10);
    spindle_lengths = data_cell(2:end,6);
    %find the empty cells in spindle lengths
    spindle_lengths_empty = cellfun(@isempty,spindle_lengths);
    kMT_1_empty = cellfun(@isempty,kMT_1);
    kMT_2_empty = cellfun(@isempty,kMT_2);
    if max(spindle_lengths_empty) == 1 || max(kMT_1_empty) == 1 ||...
            max(kMT_2_empty) == 1
        %remove the empty rows from kMT_1 and kMT_2 and spindle_lengths
        total_empty = spindle_lengths_empty + kMT_1_empty + kMT_2_empty;
        kMT_1 = kMT_1(total_empty==0);
        kMT_2 = kMT_2(total_empty==0);
        spindle_lengths = spindle_lengths(total_empty==0);
    end
    %Calc absolute difference of kmts and output cell array with filename
    diff_array = cellfun(@minus,kMT_1,kMT_2);
    diff_array = abs(diff_array);
    mean_diff = mean(diff_array);
    std_diff = std(diff_array,1);
    kmt_diffs{n,1} = files(n).name;
    kmt_diffs{n,2} = mean_diff;
    kmt_diffs{n,3} = std_diff;
    

end

end