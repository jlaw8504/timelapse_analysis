function H = plasmid_heatmap(x,y,xmin,xmax,xbin,ymin,ymax,ybin)
%This function is designed to parse the initial signal lengths and the
%change in signal length of the pT431 plasmid.  The output is a matrix that
%can generate a heatmap. bfactor is the fold number of binning you want to
%use

%% Construct H
xDim = linspace(xmin,xmax,xbin)';
yDim = linspace(ymin,ymax,ybin)';
H = zeros(length(yDim),length(xDim));
for l = 1:length(x)
    countX = dsearchn(xDim, x(l));
    countY = dsearchn(yDim, y(l));
    H(countY,countX) = H(countY,countX) + 1 ;
end
%Normalize H
H = H./max(H(:));
H = H - 0.5;
%% Create the heatmap
HeatMap(H,'Colormap',redbluecmap(11));
end