Triggers = MARCS_vars.Task_trigs;
Brain_MSE = MARCS_vars.MSE_Task;
stim_trigs = [201:206,211:216,1:96]';
%%
Proc_Task = cell(17,1);
for part = 1:17
    tempdata = Brain_MSE(:,part);%get the participant's brain MSE
    temptrigs = Triggers{part};% get the participant's triggers
    tempmat = nan(144,64);%pre-allocate a matrix for the data
    for trig = 1:length(temptrigs)% for each trigger
        tempstim = temptrigs(trig);% get the participant's trigger label 
        if tempstim > 100 && tempstim <200% if it's S2 position, remove the 100
            tempstim = tempstim-100;
        end
        tempdex = find(stim_trigs==tempstim);% find the brain trigger in the stimulus index
        temp_stim_mse = stim_mse(tempdex,:);% get the stimulus mse values
        temp_brain_mse = tempdata{trig};% get the brain MSE
        for trode = 1:length(temp_brain_mse)% almost there...for each electrode...
            temp_proc = procrustes(temp_brain_mse(trode,:)',temp_stim_mse');% calculate procrustes
            tempmat(trig,trode) = temp_proc;% put it in the temp variable
        end
    end
    Proc_Task{part} = tempmat;% then into the cell array!
end

clear part trig trode temp*

%%
Proc_Block = cell(17,6);
for part = 1:17
   temp_trigs = MARCS_vars.Task_trigs{part};
   temp_data = Proc_Task{part};
   rp_dex = find(temp_trigs>=201&temp_trigs<=206);
   ip_dex = find(temp_trigs>=211&temp_trigs<=216);
   temp_rp = temp_data(rp_dex,:);
   temp_regs1 = temp_data(rp_dex+1,:);
   temp_regs2 = temp_data(rp_dex+2,:);
   temp_irrp = temp_data(ip_dex,:);
   temp_irrs1 = temp_data(ip_dex+1,:);
   temp_irrs2 = temp_data(ip_dex+2,:);

   Proc_Block{part,1} = temp_rp;
   Proc_Block{part,2} = temp_regs1;
   Proc_Block{part,3} = temp_regs2;
   Proc_Block{part,4} = temp_irrp;
   Proc_Block{part,5} = temp_irrs1;
   Proc_Block{part,6} = temp_irrs2;
end
clear temp* *_dex
%% Get the data into PLS shape
PLS_Proc = cell(6,1);

for cond = 1:6
    tempmat = nan(17,64);
    for part = 1:17
    tempdata = Proc_Block{part,cond};
    tempmat(part,:) = mean(tempdata);
    end
    PLS_Proc{cond} = tempmat;
end
clear cond part temp*
%% PLS TIME!

clear option % make sure an old option file isn't kicking around

% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_all = cell2mat(PLS_Proc);
indata_all(isnan(indata_all)) = 0;
nparts = 17;% number of participants you have
ncond = 6;% number of conditions you have

Proc_res = pls_analysis({indata_all}, nparts, ncond,[option]);%running the PLS

pvals = Proc_res.perm_result.sprob;
%% Step 4: Plot mean-centred PLS results

res =MARCS_vars.ProcResults.all_res; % what results you want to plot
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('ALL Res, p = %f',p);% the title with the p value
xlabs = {'Reg Prime' ,'Reg S1','Reg S2',...
    'Irreg Prime','Irreg S1','Irreg S2'};

figure
subplot(1,2,1)
z = res.boot_result.orig_usc;
limit = length(z);
bar(z(:,LV))
hold on
yneg = res.boot_result.llusc(1:limit,LV);
ypos = res.boot_result.ulusc(1:limit,LV);
errorbar(1:length(z(1:limit,LV)),z(1:limit,LV),yneg-z(1:limit,LV),ypos-z(1:limit,LV),'.')
colorbar off
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels(xlabs)
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<2.5) = nan;
plotdata = reshape(x,64,[]);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(parula)
%clim([-6 6])
colorbar
xticks([])
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))     
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images:
xlabs = {'Reg Prime','Reg S1','Reg S2','Irreg Prime','Irreg S1','Irreg S2'};
start = 1;
plotdata = nan(64,6);
for i = 1:6
    tempdata = indata_all(start:start+16,:);
    tempdata = mean(tempdata);
    tempdata = reshape(tempdata,64,[]);
    plotdata(:,i) = tempdata;
    start = start+17;
end
clear i start temp*
%%
figure
shower_tile_plot(plotdata)
colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
clim([0 0.9])
grid on
xticks(1.5:6.5)
xticklabels(xlabs)
xtickangle(45)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('Procrustes Distance Input Data','FontSize',16)
colorbar
%% And now mask it:
res = MARCS_vars.ProcResults.all_res;
x = (res.boot_result.compare_u(:,1));
x(abs(x)<2.5) = 0;
x(abs(x)~=0) = 1;
mask = reshape(x,64,[]);

for i = 1:6
    mask_plot(:,i) = plotdata(:,i).*mask;
end
mask_plot(mask_plot==0) = nan;
clear res x %mask
%% Plot the masked data
figure
shower_tile_plot(mask_plot);
%colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
%clim([0 0.9])
xticks(1.5:6.5)
xticklabels(xlabs)
xtickangle(45)
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))
ylabel('Electrode')
title('Procrustes Distance Masked Input Data','FontSize',16)
colorbar
%% Overall Language TIME!
Reg_all = cat(3,PLS_Proc{2:3});
Reg_all = nanmean(Reg_all,3);
Irreg_all = cat(3,PLS_Proc{5:6});
Irreg_all = nanmean(Irreg_all,3);
%% Do the language analysis
clear option % make sure an old option file isn't kicking around

% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_sentence = [Reg_all;Irreg_all];
nparts = 17;% number of participants you have
ncond = 2;% number of conditions you have

ProcLang_res = pls_analysis({indata_sentence}, nparts, ncond,[option]);%running the PLS

pvals = ProcLang_res.perm_result.sprob;

%% Step 4: Plot mean-centred PLS results

res =MARCS_vars.ProcResults.ProcLang_res; % what results you want to plot
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Language Res, p = %f',p);% the title with the p value
xlabs = {'Reg Prime Sentence' ,'Irreg Prime Sentence'};

figure
subplot(1,2,1)
z = res.boot_result.orig_usc;
limit = length(z);
bar(z(:,LV))
hold on
yneg = res.boot_result.llusc(1:limit,LV);
ypos = res.boot_result.ulusc(1:limit,LV);
errorbar(1:length(z(1:limit,LV)),z(1:limit,LV),yneg-z(1:limit,LV),ypos-z(1:limit,LV),'.')
colorbar off
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels(xlabs)
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<2.5) = nan;
plotdata = reshape(x,64,[]);
subplot(1,2,2)
shower_tile_plot(plotdata);
%colormap(rgb)
clim([-3 3])
colorbar
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))     
ylabel('Electrodes')
xlabel([])
title(sprintf('Procrustes LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Mask and plot the indata:
xlabs = {'Reg Prime Sentences','Irreg Prime Sentences'};
start = 1;
plotdata = nan(64,2);
for i = 1:2
    tempdata = indata_sentence(start:start+16,:);
    tempdata = mean(tempdata);
    tempdata = reshape(tempdata,64,[]);
    plotdata(:,i) = tempdata;
    start = start+17;
end
clear i start temp*
res = MARCS_vars.ProcResults.ProcLang_res;
x = (res.boot_result.compare_u(:,1));
x(abs(x)<2.5) = 0;
x(abs(x)~=0) = 1;
mask = reshape(x,64,[]);

clear mask_plot

for i = 1:2
    mask_plot(:,i) = plotdata(:,i).*mask;
end
mask_plot(mask_plot==0) = nan;
clear res x %mask
%% Plot the masked data
figure
shower_tile_plot(mask_plot);
%colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
%clim([0 0.9])
xticks(1.5:6.5)
xticklabels(xlabs)
xtickangle(45)
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))
ylabel('Electrode')
title('Procrustes Distance Masked Input Data','FontSize',16)
colorbar
%% Do the prime analysis!
% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_prime = [PLS_Proc{1};PLS_Proc{4}];
nparts = 17;% number of participants you have
ncond = 2;% number of conditions you have

ProcPrime_res = pls_analysis({indata_prime}, nparts, ncond,[option]);%running the PLS

pvals = ProcPrime_res.perm_result.sprob;
% Non-sig differences!
%% Plot the indata as lines:
xlabs = {'Reg Rhythmic Prime','Irreg Rhythmic Prime'};
start = 1;
figure
for i = 1:2
    subplot(1,2,i)
    plotdata = indata_prime(start:start+16,:);
    plotdata = mean(plotdata);
    colormap(rgb(1:11,:))
    imagesc(plotdata')
    colorbar
    %hold on
    %grid on
    start = start+17;
    yticks(1:64)
    yticklabels(First_Results.Labels)
    clim([0 1])
    title(xlabs{i},'FontSize',16)
end
clear i start
%% Step 4: Plot mean-centred PLS results

res =ProcPrime_res; % what results you want to plot
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Prime Res, p = %f',p);% the title with the p value
xlabs = {'Reg Prime' ,'Irreg Prime'};

figure
subplot(1,2,1)
z = res.boot_result.orig_usc;
limit = length(z);
bar(z(:,LV))
hold on
yneg = res.boot_result.llusc(1:limit,LV);
ypos = res.boot_result.ulusc(1:limit,LV);
errorbar(1:length(z(1:limit,LV)),z(1:limit,LV),yneg-z(1:limit,LV),ypos-z(1:limit,LV),'.')
colorbar off
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels(xlabs)
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<3) = nan;
plotdata = reshape(x,64,[]);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(rgb)
clim([-7 7])
colorbar
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))     
xticks([])
ylabel('Electrodes')
xlabel('Procrustes')
title(sprintf('Procrustes Distance LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images:
xlabs = {'Reg Rhythms Prime' ,'Irreg Rhythms Prime'};
start = 1;
figure
for i = 1:2
    plotdata = indata_prime(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    subplot(1,2,i)
    imagesc(plotdata)
    %colormap(parula)
    colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
    clim([0 1])
    yticks(1:64)
    yticklabels(First_Results.Labels)
    grid on
    ylabel('Electrode')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
clear option % make sure an old option file isn't kicking around
%% Separate out S1 and S2!
Reg_all = (PLS_Proc(2:3));
Irreg_all = (PLS_Proc(5:6));
%% Do the language analysis again!
clear option % make sure an old option file isn't kicking around

% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_sentence = [cell2mat(Reg_all);cell2mat(Irreg_all)];
nparts = 17;% number of participants you have
ncond = 4;% number of conditions you have

ProcLang2_res = pls_analysis({indata_sentence}, nparts, ncond,[option]);%running the PLS

pvals = ProcLang2_res.perm_result.sprob;

%% Plot the indata as images:
xlabs = {'Reg S1','Reg S2','Irreg S1','Irreg S2'};
start = 1;
plotdata = nan(64,4);
for i = 1:4
    tempdata = indata_sentence(start:start+16,:);
    tempdata = mean(tempdata);
    tempdata = reshape(tempdata,64,[]);
    plotdata(:,i) = tempdata;
    start = start+17;
end
clear i start temp*
%%
figure
shower_tile_plot(plotdata)
colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
clim([0.4 1])
grid on
xticks(1.5:6.5)
xticklabels(xlabs)
xtickangle(45)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('Procrustes Distance Sentence Data','FontSize',16)
colorbar
%% Step 4: Plot mean-centred PLS results

res =MARCS_vars.ProcResults.ProcLang2_res; % what results you want to plot
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Language Res, p = %f',p);% the title with the p value
xlabs = {'Reg Prime S1','Reg Prime S2','Irreg Prime S1','Irreg Prime S2'};

figure
subplot(1,2,1)
z = res.boot_result.orig_usc;
limit = length(z);
bar(z(:,LV))
hold on
yneg = res.boot_result.llusc(1:limit,LV);
ypos = res.boot_result.ulusc(1:limit,LV);
errorbar(1:length(z(1:limit,LV)),z(1:limit,LV),yneg-z(1:limit,LV),ypos-z(1:limit,LV),'.')
colorbar off
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels(xlabs)
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<2.5) = nan;
plotdata = reshape(x,64,[]);
subplot(1,2,2)
shower_tile_plot(plotdata);
%colormap(rgb)
clim([-4 4])
colorbar
xticks([])
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))     
ylabel('Electrodes')
title(sprintf('Procrustes Distance LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% And now mask it:
clear mask_plot
res = MARCS_vars.ProcResults.ProcLang2_res;
x = (res.boot_result.compare_u(:,1));
x(abs(x)<2.5) = 0;
x(abs(x)~=0) = 1;
mask = reshape(x,64,[]);

xlabs = {'Reg S1','Reg S2','Irreg S1','Irreg S2'};
start = 1;
plotdata = nan(64,4);
for i = 1:4
    tempdata = indata_sentence(start:start+16,:);
    tempdata = mean(tempdata);
    tempdata = reshape(tempdata,64,[]);
    plotdata(:,i) = tempdata;
    start = start+17;
end
clear i start temp*

for i = 1:4
    mask_plot(:,i) = plotdata(:,i).*mask;
end
mask_plot(mask_plot==0) = nan;
clear res x %mask
%% Plot the masked data
figure
shower_tile_plot(mask_plot);
%colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
%clim([0 0.9])
xticks(1.5:6.5)
xticklabels(xlabs)
xtickangle(45)
yticks(1.5:64.5)
yticklabels(flipud(MARCS_vars.Labels))
ylabel('Electrode')
title('Procrustes Distance Masked Input Data','FontSize',16)
colorbar
%% With labels!
x = repmat(1:4,4,1);
y = repmat(1:64,1,64);
t = num2cell(mask_plot); % extact values into cells
t = cellfun(@num2str, t, 'UniformOutput', false); % convert to string

figure
heatmap(mask_plot);
colormap(rgb)
%text(x(:),y(:),t,'HorizontalAlignment','Center')
%% Plot the indata as images:
xlabs = {'Reg Prime S1','Reg Prime S2','Irreg Prime S1','Irreg Prime S2'};
start = 1;
figure
for i = 1:4
    plotdata = indata_sentence(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    subplot(2,2,i)
    imagesc(plotdata)
    %colormap(parula)
    %colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
    clim([0.4 0.9])
    grid on
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% Add everything to the array:
MARCS_vars.stim_mse = stim_mse;
MARCS_vars.Proc_Block = Proc_Block;
MARCS_vars.PLS_Proc = PLS_Proc;

MARCS_vars.ProcResults.all_res = Proc_res;
MARCS_vars.ProcResults.ProcLang_res = ProcLang_res;
MARCS_vars.ProcResults.ProcLang2_res = ProcLang2_res;
MARCS_vars.ProcResults.ProcPrime_res = ProcPrime_res;
MARCS_vars.Labels = First_Results.Labels;