function [ ensemble_spindle_mean, ensemble_spindle_std, spindle_means, spindle_stds ]...
    = timelapse_spindle_std_stretch_only( directory, threshold )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    %% Load in the data structure
    data = load(files(n).name);
    data_cell = data.data_cell;
    %% Load in the necessary variables
    spindle_length = data_cell(2:end,6);
    aspect_ratios = data_cell(2:end,4);
    split = data_cell(2:end,11);
    %% Find undesired cells
    %find the empty cells in imported variables
    spindle_empty = cellfun(@isempty,spindle_length);
    aspect_emtpy = cellfun(@isempty,aspect_ratios);
    split_empty = cellfun(@isempty,split);
    %merge the empty indices
    all_empty = spindle_empty | aspect_emtpy | split_empty;
    %filter out all the empty cells
    spindle_length = spindle_length(~all_empty);
    aspect_ratios = aspect_ratios(~all_empty);
    split = split(~all_empty);
    %filter out the undesired cells
    stretch_index = cellfun(@(x) x > threshold,aspect_ratios);
    %index which cells are whole (not split)
    split = logical(cell2mat(split));
    whole = ~split;
    include = stretch_index & whole;
    %% Remove undesirable cells by indexing
    spindle_length = spindle_length(include);
    %% Run calculations on desired cells
    %Calc mean and std of signal length
    spindle_mean = mean(cell2mat(spindle_length));
    spindle_means(n) = spindle_mean;
    spindle_std = std(cell2mat(spindle_length),1);
    spindle_stds(n) = spindle_std;   
end

ensemble_spindle_mean = mean(spindle_means);
ensemble_spindle_std = mean(spindle_stds);

end