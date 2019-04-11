function [ diff_mean, diff_std ] = timelapse_kMT_diff( directory )
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
    %Calc ratio of kMT_1 + kMT_2 to spindle length
    ratio_1 = cellfun(@rdivide,kMT_1,spindle_lengths);
    ratio_2 = cellfun(@rdivide,kMT_2,spindle_lengths);
    ratio = ratio_1 + ratio_2;
    ratios{n} = ratio;
    means(n) = mean(ratio);
    stds(n) = std(ratio,1);
end

end