%Script for producing all figures for percent change in length vs initial
%length and change in length vs intial length for all yeast strains.

%% Instantiate variables
%Directories for strains
brn = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/brn';
mcm21 = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/mcm21';
sir2 = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/sir2';
wt24 = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/wt24';
wt37 = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/wt37';
yku80 = '/Volumes/BloomLab/Josh/~Dicentric_project/~Timelapse_30sINT_20mDUR/allData/yku80';
%plane distance (distance in Z-planes which the GFP spots must be within to 
%be measured)
plane_distance = 3;
%% Run the distance_rate_analysis function
[brn_lengthMat, brn_changeMat, brn_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (brn, plane_distance, 'brn1-9 37°C');

[mcm21_lengthMat, mcm21_changeMat, mcm21_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (mcm21, plane_distance, 'mcm21? 24°C');

[sir2_lengthMat, sir2_changeMat, sir2_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (sir2, plane_distance, 'sir2? 24°C');

[wt24_lengthMat, wt24_changeMat, wt24_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (wt24, plane_distance, 'WT 24°C');

[wt37_lengthMat, wt37_changeMat, wt37_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (wt37, plane_distance, 'WT 37°C');

[yku80_lengthMat, yku80_changeMat, yku80_normMat] =...
    timelapse_signal_changes_vs_siglength_infocus...
    (yku80, plane_distance, 'yku80? 24°C');
%% Close all the output from above
close all;
%% Run the plasmid_heatmap function for each
%change vs initial length section
xmin = 200;
xmax = 2200;
ymin = -1000;
ymax = 1000;
xbin = 50;
ybin = 50;
brn_H = plasmid_heatmap(brn_lengthMat,brn_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);
wt37_H = plasmid_heatmap(wt37_lengthMat,wt37_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);
wt24_H = plasmid_heatmap(wt24_lengthMat,wt24_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);
mcm21_H = plasmid_heatmap(mcm21_lengthMat,mcm21_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);
sir2_H = plasmid_heatmap(sir2_lengthMat,sir2_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);
yku80_H = plasmid_heatmap(yku80_lengthMat,yku80_changeMat,xmin,xmax,xbin,ymin,ymax,ybin);