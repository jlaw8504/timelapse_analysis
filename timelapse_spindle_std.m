function [ ensemble_spindle_mean, ensemble_spindle_std, spindle_means, spindle_stds ]...
    = timelapse_spindle_std( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    spindle_length = data_cell(2:end,6);
    %find the empty cells in major axes
    spindle_empty = cellfun(@isempty,spindle_length);
    %remove the empty rows from major_axes
    spindle_length = spindle_length(spindle_empty==0);
    %Calc mean and std of signal length
    spindle_mean = mean(cell2mat(spindle_length));
    spindle_means(n) = spindle_mean;
    spindle_std = std(cell2mat(spindle_length),1);
    spindle_stds(n) = spindle_std;   
end

ensemble_spindle_mean = mean(spindle_means);
ensemble_spindle_std = mean(spindle_stds);

end