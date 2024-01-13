%% And now we do some PLSes! 
% We have MSE data, we have triggers, now we need to get! Organized!

%% Set up some filters!
Reg_Prime = 201:206;% regular prime
Irr_Prime = 211:216;% irregular prime
S1 = 1:96;% sentence in first position
S2 = 101:196;% sentence in second position
%% 
MSE_vec = cell(17,1);
for part = 1:17
    tempdata = MARCS_vars.MSE_Task(:,part);
    tempmat = nan(144,64*40);
    for i = 1:144
        tempmat(i,:) = reshape(tempdata{i},1,[]);
    end
    MSE_vec{part} = tempmat;
end
clear i part temp*
%%
MSE_Block = cell(17,6);
for part = 1:17
   temp_trigs = MARCS_vars.Task_trigs{part};
   temp_data = MSE_vec{part};
   rp_dex = find(temp_trigs>=201&temp_trigs<=206);
   ip_dex = find(temp_trigs>=211&temp_trigs<=216);
   temp_rp = temp_data(rp_dex,:);
   temp_regs1 = temp_data(rp_dex+1,:);
   temp_regs2 = temp_data(rp_dex+2,:);
   temp_irrp = temp_data(ip_dex,:);
   temp_irrs1 = temp_data(ip_dex+1,:);
   temp_irrs2 = temp_data(ip_dex+2,:);

   MSE_Block{part,1} = temp_rp;
   MSE_Block{part,2} = temp_regs1;
   MSE_Block{part,3} = temp_regs2;
   MSE_Block{part,4} = temp_irrp;
   MSE_Block{part,5} = temp_irrs1;
   MSE_Block{part,6} = temp_irrs2;
end
clear temp* *_dex
%% Get the data into PLS shape
PLS_Block = cell(6,1);

for cond = 1:6
    tempmat = nan(17,2560);
    for part = 1:17
    tempdata = MSE_Block{part,cond};
    tempmat(part,:) = mean(tempdata);
    end
    PLS_Block{cond} = tempmat;
end
clear cond part temp*
%% PLS TIME!

clear option % make sure an old option file isn't kicking around

% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_all = cell2mat(PLS_Block);
indata_all(isnan(indata_all)) = 0;
nparts = 17;% number of participants you have
ncond = 6;% number of conditions you have

Cond_res = pls_analysis({indata_all}, nparts, ncond,[option]);%running the PLS

pvals = Cond_res.perm_result.sprob;
%% Colormap:
% ie. how we make this look like matplotlib :D
rgb = [ ...   
    94    79   162
    72   104   175
    50   136   189
    76   160   177
   102   194   165
   136   210   165
   171   221   164
   200   233   158
   230   245   152
   243   250   199
   255   255   255  % 0 is white
   255   230   195
   254   224   139
   253   200   120
   253   174    97
   249   141    82
   244   109    67
   230    87    88
   213    62    79
   182    33    72
   158     1    66  ] / 255; 
%% Step 4: Plot mean-centred PLS results

res =Cond_res; % what results you want to plot
LV = 2;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('ALL Res, p = %f',p);% the title with the p value
xlabs = {'Reg Prime' ,'S1','S2',...
    'Irreg Prime','S1','S2'};

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
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(parula)
clim([-6 6])
colorbar
xticks(5:5:40)
yticks([])
%yticklabels()     
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images:
xlabs = {'Reg Prime' ,'Irreg Prime','S1','S1',...
    'S2','S2'};
start = 1;
figure
for i = [1,3,5,2,4,6]
    plotdata = indata_all(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    subplot(3,2,i)
    imagesc(plotdata)
    %colormap(parula)
    colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
    clim([0 0.8])
    grid on
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start

%% Plot the indata as lines:
xlabs = {'Reg Prime','S1','S2',...
    'Irreg Prime','S1','S2'};
start = 1;
figure
for i = 1:6
    plotdata = indata_all(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = mean(plotdata);
    plot(plotdata,'LineWidth',2)
    hold on
    grid on
    start = start+17;
end
    xlabel('MSE Scale')
    legend(xlabs,'FontSize',16)
clear i start
%% Overall PLS TIME!
Reg_all = cat(3,PLS_Block{2:3});
Reg_all = nanmean(Reg_all,3);
Irreg_all = cat(3,PLS_Block{5:6});
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

Lang_res = pls_analysis({indata_sentence}, nparts, ncond,[option]);%running the PLS

pvals = Lang_res.perm_result.sprob;

%% Plot the indata as lines:
xlabs = {'Reg Prime','Irreg Prime'};
start = 1;
figure
for i = 1:2
    plotdata = indata_sentence(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = mean(plotdata);
    plot(plotdata,'LineWidth',2)
    hold on
    grid on
    start = start+17;
end
    xlabel('MSE Scale')
    legend(xlabs,'FontSize',16)
    title('Indata Sentences only','FontSize',16)
clear i start
%% Step 4: Plot mean-centred PLS results

res =Lang_res; % what results you want to plot
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Language Res, p = %f',p);% the title with the p value
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
x(abs(x)<2) = nan;
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(rgb)
clim([-4 4])
colorbar
xticks(5:5:40)
yticks([])
%yticklabels()     
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images:
xlabs = {'Reg Prime' ,'Irreg Prime'};
start = 1;
figure
for i = 1:2
    plotdata = indata_all(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    subplot(1,2,i)
    imagesc(plotdata)
    %colormap(parula)
    colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
    clim([0 0.9])
    grid on
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
clear option % make sure an old option file isn't kicking around
%% Do the prime analysis!
% Now, make a new option file
option.method = 1;% Mean-centred PLS
option.num_perm = 500;
option.num_boot = 100;

indata_prime = [PLS_Block{1};PLS_Block{2}];
nparts = 17;% number of participants you have
ncond = 2;% number of conditions you have

Prime_res = pls_analysis({indata_prime}, nparts, ncond,[option]);%running the PLS

pvals = Prime_res.perm_result.sprob;

%% Plot the averaged indata curves
xlabs = {'Reg Prime','Irreg Prime'};
start = 1;
figure
for i = 1:2
    plotdata = indata_prime(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = mean(plotdata);
    plot(plotdata,'LineWidth',2)
    hold on
    grid on
    start = start+17;
end
    xlabel('MSE Scale')
    legend(xlabs,'FontSize',16)
clear i start
%% Step 4: Plot mean-centred PLS results

res =Prime_res; % what results you want to plot
LV = 2;% What LV you want to plot
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
x(abs(x)<2) = nan;
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(rgb)
clim([-5 5])
colorbar
xticks(5:5:40)
yticks([])
%yticklabels()     
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images:
xlabs = {'Reg Prime' ,'Irreg Prime'};
start = 1;
figure
for i = 1:2
    plotdata = indata_prime(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    subplot(1,2,i)
    %imagesc(plotdata)
    shower_tile_plot(plotdata)
    %colormap(parula)
    colormap(rgb(1:11,:))%still not super happy with interpretability here...need more colours
    clim([0 0.8])
    grid on
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% Add everything to the array:
MARCS_vars.MSE_vec = MSE_vec;
MARCS_vars.MSE_Block = MSE_Block;
MARCS_vars.PLS_Block = PLS_Block;

MARCS_vars.Results.Cond_res = Cond_res;
MARCS_vars.Results.Lang_res = Lang_res;
MARCS_vars.Results.Prime_res = Prime_res;