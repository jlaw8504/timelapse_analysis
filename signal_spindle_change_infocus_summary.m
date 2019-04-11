function [signal_table, spindle_table] = signal_spindle_change_infocus_summary(mut_dir, mut_name, WT_dir, WT_temp, data_name,plane_distance)

% I want to summarize the change in spindle and signal lengths
% into a single function so I don't have to worry about stupid mistakes
directory = cd;
%% Run the spindle and signal change functions on the mutant and WT strains
[ mut_sig_changes ] = timelapse_signal_changes_infocus( mut_dir,plane_distance );
[ mut_spin_changes ] = timelapse_spindle_changes_infocus( mut_dir,plane_distance );
[ WT_sig_changes ] = timelapse_signal_changes_infocus( WT_dir,plane_distance );
[ WT_spin_changes ] = timelapse_spindle_changes_infocus( WT_dir,plane_distance );

%% Divide the changes by the timestep to convert to rate (nm/s)
mut_sig_changes = mut_sig_changes./30;
mut_spin_changes = mut_spin_changes./30;
WT_sig_changes = WT_sig_changes./30;
WT_spin_changes = WT_spin_changes./30;

%% Calculate the mean rate of growth and shrinking
% use logical indexing to get growth and shrink rates
mut_sig_growth = mut_sig_changes(mut_sig_changes > 0);
mut_sig_shrink = mut_sig_changes(mut_sig_changes < 0);
mut_spin_growth = mut_spin_changes(mut_spin_changes > 0);
mut_spin_shrink = mut_spin_changes(mut_spin_changes < 0);
WT_sig_growth = WT_sig_changes(WT_sig_changes > 0);
WT_sig_shrink = WT_sig_changes(WT_sig_changes < 0);
WT_spin_growth = WT_spin_changes(WT_spin_changes > 0);
WT_spin_shrink = WT_spin_changes(WT_spin_changes < 0);
% Calculate the mean of each of these
mean_mut_sig_growth = mean(mut_sig_growth,'omitnan');
mean_mut_sig_shrink = mean(mut_sig_shrink,'omitnan');
mean_mut_spin_growth = mean(mut_spin_growth,'omitnan');
mean_mut_spin_shrink = mean(mut_spin_shrink,'omitnan');
mean_WT_sig_growth = mean(WT_sig_growth,'omitnan');
mean_WT_sig_shrink = mean(WT_sig_shrink,'omitnan');
mean_WT_spin_growth = mean(WT_spin_growth,'omitnan');
mean_WT_spin_shrink = mean(WT_spin_shrink,'omitnan');

% Calculate the std of each of these
std_mut_sig_growth = std(mut_sig_growth,'omitnan');
std_mut_sig_shrink = std(mut_sig_shrink,'omitnan');
std_mut_spin_growth = std(mut_spin_growth,'omitnan');
std_mut_spin_shrink = std(mut_spin_shrink,'omitnan');
std_WT_sig_growth = std(WT_sig_growth,'omitnan');
std_WT_sig_shrink = std(WT_sig_shrink,'omitnan');
std_WT_spin_growth = std(WT_spin_growth,'omitnan');
std_WT_spin_shrink = std(WT_spin_shrink,'omitnan');

%% Test the normality of the growth and shrinkage distributions
ks_WT_sig_growth_h = kstest(WT_sig_growth);
ks_WT_sig_shrink_h = kstest(WT_sig_shrink);
ks_WT_spin_growth_h = kstest(WT_spin_growth);
ks_WT_spin_shrink_h = kstest(WT_spin_shrink);
ks_mut_sig_growth_h = kstest(mut_sig_growth);
ks_mut_sig_shrink_h = kstest(mut_sig_shrink);
ks_mut_spin_growth_h = kstest(mut_spin_growth);
ks_mut_spin_shrink_h = kstest(mut_spin_shrink);

%% Test if the variances of the WT and mut are same based on normality
% signal growth
if ks_WT_sig_growth_h == 0 && ks_mut_sig_growth_h == 0
    ft_sig_growth_h = vartest2(WT_sig_growth,mut_sig_growth);
    if ft_sig_growth_h == 0
        [~,tt_sig_growth_p] = ttest2(WT_sig_growth,mut_sig_growth,...
            'VarType','equal');
    else
        [~,tt_sig_growth_p] = ttest2(WT_sig_growth,mut_sig_growth,...
            'VarType','unequal');
    end
else
    % Compare the stds of the changes of mut and WT using Brown-Forsythe test
    bf_p_sig_growth = vartestn([WT_sig_growth;mut_sig_growth],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_sig_growth,1),1);...
        repmat({mut_name},size(mut_sig_growth,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_sig_growth < 0.05 %there is difference in variances
        [~,ttest_mean_sig_growth_p] = ttest2(WT_sig_growth,...
            mut_sig_growth,'VarType','unequal');
    else
        [~,ttest_mean_sig_growth_p] = ttest2(WT_sig_growth,...
            mut_sig_growth,'VarType','equal');
    end
end

% signal shrink
if ks_WT_sig_shrink_h == 0 && ks_mut_sig_shrink_h == 0
    ft_sig_shrink_h = vartest2(WT_sig_shrink,mut_sig_shrink);
    if ft_sig_shrink_h == 0
        [~,tt_sig_shrink_p] = ttest2(WT_sig_shrink,mut_sig_shrink,...
            'VarType','equal');
    else
        [~,tt_sig_shrink_p] = ttest2(WT_sig_shrink,mut_sig_shrink,...
            'VarType','unequal');
    end
else
    % Compare the stds of the changes of mut and WT using Brown-Forsythe test
    bf_p_sig_shrink = vartestn([WT_sig_shrink;mut_sig_shrink],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_sig_shrink,1),1);...
        repmat({mut_name},size(mut_sig_shrink,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_sig_shrink < 0.05 %there is difference in variances
        [~,ttest_mean_sig_shrink_p] = ttest2(WT_sig_shrink,...
            mut_sig_shrink,'VarType','unequal');
    else
        [~,ttest_mean_sig_shrink_p] = ttest2(WT_sig_shrink,...
            mut_sig_shrink,'VarType','equal');
    end
end
% spindle rates
% spinnal growth
if ks_WT_spin_growth_h == 0 && ks_mut_spin_growth_h == 0
    ft_spin_growth_h = vartest2(WT_spin_growth,mut_spin_growth);
    if ft_spin_growth_h == 0
        [~,tt_spin_growth_p] = ttest2(WT_spin_growth,mut_spin_growth,...
            'VarType','equal');
    else
        [~,tt_spin_growth_p] = ttest2(WT_spin_growth,mut_spin_growth,...
            'VarType','unequal');
    end
else
    % Compare the stds of the changes of mut and WT using Brown-Forsythe test
    bf_p_spin_growth = vartestn([WT_spin_growth;mut_spin_growth],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_spin_growth,1),1);...
        repmat({mut_name},size(mut_spin_growth,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_spin_growth < 0.05 %there is difference in variances
        [~,ttest_mean_spin_growth_p] = ttest2(WT_spin_growth,...
            mut_spin_growth,'VarType','unequal');
    else
        [~,ttest_mean_spin_growth_p] = ttest2(WT_spin_growth,...
            mut_spin_growth,'VarType','equal');
    end
end

% spinnal shrink
if ks_WT_spin_shrink_h == 0 && ks_mut_spin_shrink_h == 0
    ft_spin_shrink_h = vartest2(WT_spin_shrink,mut_spin_shrink);
    if ft_spin_shrink_h == 0
        [~,tt_spin_shrink_p] = ttest2(WT_spin_shrink,mut_spin_shrink,...
            'VarType','equal');
    else
        [~,tt_spin_shrink_p] = ttest2(WT_spin_shrink,mut_spin_shrink,...
            'VarType','unequal');
    end
else
    % Compare the stds of the changes of mut and WT using Brown-Forsythe test
    bf_p_spin_shrink = vartestn([WT_spin_shrink;mut_spin_shrink],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_spin_shrink,1),1);...
        repmat({mut_name},size(mut_spin_shrink,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_spin_shrink < 0.05 %there is difference in variances
        [~,ttest_mean_spin_shrink_p] = ttest2(WT_spin_shrink,...
            mut_spin_shrink,'VarType','unequal');
    else
        [~,ttest_mean_spin_shrink_p] = ttest2(WT_spin_shrink,...
            mut_spin_shrink,'VarType','equal');
    end
end
%% Convert the changes to abs values
mut_sig_changes_abs = abs(mut_sig_changes);
mut_spin_changes_abs = abs(mut_spin_changes);
WT_sig_changes_abs = abs(WT_sig_changes);
WT_spin_changes_abs = abs(WT_spin_changes);
%% Calculate mean of the changes
mean_mut_sig_changes = mean(mut_sig_changes,'omitnan');
mean_mut_spin_changes = mean(mut_spin_changes,'omitnan');
mean_WT_sig_changes = mean(WT_sig_changes,'omitnan');
mean_WT_spin_changes = mean(WT_spin_changes,'omitnan');
%% Calculate the mean of the abs of the changes
mean_mut_sig_changes_abs = mean(mut_sig_changes_abs,'omitnan');
mean_mut_spin_changes_abs = mean(mut_spin_changes_abs,'omitnan');
mean_WT_sig_changes_abs = mean(WT_sig_changes_abs,'omitnan');
mean_WT_spin_changes_abs = mean(WT_spin_changes_abs,'omitnan');

%% Calculate the std of the of the changes
std_mut_sig_changes = std(mut_sig_changes,'omitnan');
std_mut_spin_changes = std(mut_spin_changes,'omitnan');
std_WT_sig_changes = std(WT_sig_changes,'omitnan');
std_WT_spin_changes = std(WT_spin_changes,'omitnan');

%% Calculate the std of the abs of the changes
std_mut_sig_changes_abs = std(mut_sig_changes_abs,'omitnan');
std_mut_spin_changes_abs = std(mut_spin_changes_abs,'omitnan');
std_WT_sig_changes_abs = std(WT_sig_changes_abs,'omitnan');
std_WT_spin_changes_abs = std(WT_spin_changes_abs,'omitnan');

%% test normality of rate distributions with KS test
[ks_WT_sig_h,ks_WT_sig_p] = kstest(WT_sig_changes);
[ks_WT_spin_h,ks_WT_spin_p] = kstest(WT_spin_changes);
[ks_mut_sig_h,ks_mut_sig_p] = kstest(mut_sig_changes);
[ks_mut_spin_h,ks_mut_spin_p] = kstest(mut_spin_changes);
% use conditional statement to switch test type based on normality
if ks_WT_sig_h == 0 && ks_mut_sig_h == 0
    [ft_sig_h,ft_sig_p] = vartest2(WT_sig_changes,mut_sig_changes);
    % compare means and abs mean using ttest2
    if ft_sig_h == 1 %there is difference in variances
        [ttest_mean_sig_h,ttest_mean_sig_p] = ttest2(WT_sig_changes,...
            mut_sig_changes,'VarType','unequal');
        [ttest_abs_mean_sig_h,ttest_abs_mean_sig_p] = ttest2(WT_sig_changes_abs,...
            mut_sig_changes_abs,'VarType','unequal');
    else
        [ttest_mean_sig_h,ttest_mean_sig_p] = ttest2(WT_sig_changes,...
            mut_sig_changes,'VarType','equal');
        [ttest_abs_mean_sig_h,ttest_abs_mean_sig_p] = ttest2(WT_sig_changes_abs,...
            mut_sig_changes_abs,'VarType','equal');
    end
else
    % Compare the stds of the changes of mut and WT using Brown-Forsythe test
    bf_p_sig = vartestn([WT_sig_changes;mut_sig_changes],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_sig_changes,1),1);...
        repmat({mut_name},size(mut_sig_changes,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_sig < 0.05 %there is difference in variances
        [ttest_mean_sig_h,ttest_mean_sig_p] = ttest2(WT_sig_changes,...
            mut_sig_changes,'VarType','unequal');
        [ttest_abs_mean_sig_h,ttest_abs_mean_sig_p] = ttest2(WT_sig_changes_abs,...
            mut_sig_changes_abs,'VarType','unequal');
    else
        [ttest_mean_sig_h,ttest_mean_sig_p] = ttest2(WT_sig_changes,...
            mut_sig_changes,'VarType','equal');
        [ttest_abs_mean_sig_h,ttest_abs_mean_sig_p] = ttest2(WT_sig_changes_abs,...
            mut_sig_changes_abs,'VarType','equal');
    end
end
if ks_WT_spin_h == 0 && ks_mut_spin_h
    [ft_spin_h,ft_spin_p] = vartest2(WT_spin_changes,mut_spin_changes);
    % compare means and abs mean using ttest2
    if ft_spin_h == 1 %there is difference in variances
        [ttest_mean_spin_h,ttest_mean_spin_p] = ttest2(WT_spin_changes,...
            mut_spin_changes,'VarType','unequal');
        [ttest_abs_mean_spin_h,ttest_abs_mean_spin_p] = ttest2(WT_spin_changes_abs,...
            mut_spin_changes_abs,'VarType','unequal');
    else
        [ttest_mean_spin_h,ttest_mean_spin_p] = ttest2(WT_spin_changes,...
            mut_spin_changes,'VarType','equal');
        [ttest_abs_mean_spin_h,ttest_abs_mean_spin_p] = ttest2(WT_spin_changes_abs,...
            mut_spin_changes_abs,'VarType','equal');
    end
else
    bf_p_spin = vartestn([WT_spin_changes_abs;mut_spin_changes_abs],...
        [repmat({strcat('WT',num2str(WT_temp),'°C')},size(WT_spin_changes,1),1);...
        repmat({mut_name},size(mut_spin_changes,1),1)],'TestType','brownforsythe',...
        'Display','off');
    if bf_p_spin < 0.05 %there is difference in variances
        [ttest_mean_spin_h,ttest_mean_spin_p] = ttest2(WT_spin_changes,...
            mut_spin_changes,'VarType','unequal');
        [ttest_abs_mean_spin_h,ttest_abs_mean_spin_p] = ttest2(WT_spin_changes_abs,...
            mut_spin_changes_abs,'VarType','unequal');
    else
        [ttest_mean_spin_h,ttest_mean_spin_p] = ttest2(WT_spin_changes,...
            mut_spin_changes,'VarType','equal');
        [ttest_abs_mean_spin_h,ttest_abs_mean_spin_p] = ttest2(WT_spin_changes_abs,...
            mut_spin_changes_abs,'VarType','equal');
    end
end
%% Make a summary table for signal
strains = {strcat('WT',num2str(WT_temp),'°C'),mut_name,'P-value'};
if exist('bf_p_sig','var') == 1
    sig_stds = [std_WT_sig_changes;std_mut_sig_changes;bf_p_sig];
elseif exist('ft_sig_p','var') == 1
    sig_stds = [std_WT_sig_changes;std_mut_sig_changes;ft_sig_p];
end
sig_means = [mean_WT_sig_changes;mean_mut_sig_changes;ttest_mean_sig_p];
sig_means_abs = [mean_WT_sig_changes_abs;mean_mut_sig_changes_abs;ttest_abs_mean_sig_p];
sig_std_abs = [std_WT_sig_changes_abs;std_mut_sig_changes_abs;nan];
sig_mean_growth = [mean_WT_sig_growth;mean_mut_sig_growth;ttest_mean_sig_growth_p];
sig_stds_growth = [std_WT_sig_growth;std_mut_sig_growth;nan];
sig_mean_shrink = [mean_WT_sig_shrink;mean_mut_sig_shrink;ttest_mean_sig_shrink_p];
sig_stds_shrink = [std_WT_sig_shrink;std_mut_sig_shrink;nan];
signal_table = table(sig_stds,sig_means,sig_means_abs,sig_std_abs,...
    sig_mean_growth,sig_stds_growth,sig_mean_shrink,sig_stds_shrink,...
    'RowNames',strains);
%% Make a summary table for spindle
if exist('bf_p_spin','var') == 1
    spin_stds = [std_WT_spin_changes;std_mut_spin_changes;bf_p_spin];
elseif exist('ft_spin_p','var') == 1
    spin_stds = [std_WT_spin_changes;std_mut_spin_changes;ft_spin_p];
end
spin_means = [mean_WT_spin_changes;mean_mut_spin_changes;ttest_mean_spin_p];
spin_means_abs = [mean_WT_spin_changes_abs;mean_mut_spin_changes_abs;ttest_abs_mean_spin_p];
spin_std_abs = [std_WT_spin_changes_abs;std_mut_spin_changes_abs;nan];
spin_mean_growth = [mean_WT_spin_growth;mean_mut_spin_growth;ttest_mean_spin_growth_p];
spin_stds_growth = [std_WT_spin_growth;std_mut_spin_growth;nan];
spin_mean_shrink = [mean_WT_spin_shrink;mean_mut_spin_shrink;ttest_mean_spin_shrink_p];
spin_stds_shrink = [std_WT_spin_shrink;std_mut_spin_shrink;nan];

spindle_table = table(spin_stds,spin_means,spin_means_abs,spin_std_abs,...
    spin_mean_growth,spin_stds_growth,spin_mean_shrink,spin_stds_shrink,...
    'RowNames',strains);
%% Make histogram of signal changes
figure;
WT_sig_h = histogram(WT_sig_changes,'Normalization','probability',...
    'BinWidth',2);
hold on;
mut_sig_h = histogram(mut_sig_changes,'Normalization','probability',...
    'Binwidth',2);
xlabel('Rate of Signal Length Change (nm/s)');
ylabel('Frequency');
legend(sprintf('WT %d°C',WT_temp),mut_name);
%% Make histogram of spindle length changes
figure;
WT_spin_h = histogram(WT_spin_changes,'Normalization','probability',...
    'BinWidth',3);
hold on;
mut_sig_h = histogram(mut_spin_changes,'Normalization','probability',...
    'BinWidth',3);
xlabel('Rate of Spindle Length Change (nm/s)');
ylabel('Frequency');
legend(sprintf('WT %d°C',WT_temp),mut_name);
cd(directory);
save(data_name);