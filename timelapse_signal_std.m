function [ ensemble_sig_mean, ensemble_sig_std, sig_means, sig_stds ]...
    = timelapse_signal_std( directory )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% Read in the matlab data files
cd(directory);
files = dir('*.mat');
%loop through the files
for n = 1:length(files)
    data = load(files(n).name);
    data_cell = data.data_cell;
    major_axes = data_cell(2:end,2);
    %find the empty cells in major axes
    major_axes_empty = cellfun(@isempty,major_axes);
    %remove the empty rows from major_axes
    major_axes = major_axes(major_axes_empty==0);
    %Calc mean and std of signal length
    sig_mean = mean(cell2mat(major_axes));
    sig_means(n) = sig_mean;
    sig_std = std(cell2mat(major_axes),1);
    sig_stds(n) = sig_std;   
end

ensemble_sig_mean = mean(sig_means);
ensemble_sig_std = mean(sig_stds);

end