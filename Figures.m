%% Rhythmic Priming: Visualization
% So we have our results and they show us...stuff! But not in enough
% detail. So let's make some masks!

%% Step 1: get all the indata matrices:
Reg_lang = cat(3,MARCS_vars.PLS_Block{2:3});
Reg_lang = nanmean(Reg_lang,3);
Irreg_lang = cat(3,MARCS_vars.PLS_Block{5:6});
Irreg_lang = nanmean(Irreg_lang,3);

indata_all = cell2mat(MARCS_vars.PLS_Block);
indata_sentence = [Reg_lang;Irreg_lang];
indata_prime = [MARCS_vars.PLS_Block{1};MARCS_vars.PLS_Block{2}];
clear Reg* Irreg*
%% Prime Results:
res = First_Results.Prime_res;
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Prime Res, p = %f',p);% the title with the p value
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
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels({'Regular';'Irregular'})
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<3) = nan;
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(First_Results.rgb)
clim([-5 5])
colorbar
xticks(5:5:40)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

mask = plotdata;
mask(mask>0) = 1;
mask(mask<0) = -1;
mask(mask==0) = nan;

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images: Just primes
xlabs = {'Reg Prime' ,'Irreg Prime','S1','S2',...
    'S1','S2'};
start = 1;
figure
mask(isnan(mask)) = 0;
for i = 1:2
    plotdata = indata_prime(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = plotdata.*abs(mask);
    subplot(1,2,i)
    shower_tile_plot(plotdata);
    %imagesc(plotdata)
    %colormap(parula)
    colormap(flipud(rgb(1:11,:)))%
    clim([0 0.7])
    grid on
    yticks(1.5:1:65.5)
    yticklabels(flipud(First_Results.Labels))
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% Language Results:
res = First_Results.Lang_res;
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Sentence Res, p = %f',p);% the title with the p value
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
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels({'Regular';'Irregular'})
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<3) = nan;
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(First_Results.rgb)
clim([-5 5])
colorbar
xticks(5:5:40)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

mask = plotdata;
mask(mask>0) = 1;
mask(mask<0) = -1;
mask(mask==0) = nan;

clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images: Sentences
xlabs = {'Reg Prime' ,'Irreg Prime','S1','S2',...
    'S1','S2'};
start = 1;
figure
mask(isnan(mask)) = 0;
for i = 1:2
    plotdata = indata_sentence(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = plotdata.*abs(mask);
    subplot(1,2,i)
    shower_tile_plot(plotdata);
    %imagesc(plotdata)
    %colormap(parula)
    colormap(flipud(rgb(1:11,:)))%
    %clim([0 0.7])
    grid on
    yticks(1.5:1:65.5)
    yticklabels(flipud(First_Results.Labels))
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% This was hard to see, so let's subtract one from the other to bring 
% out the effect:
plotdata = indata_sentence(1:17,:);
plotdata = mean(plotdata);
plotdata = reshape(plotdata,64,[]);
plotdata = plotdata.*abs(mask);

plotdata2 = indata_sentence(18:34,:);
plotdata2 = mean(plotdata2);
plotdata2 = reshape(plotdata2,64,[]);
plotdata2 = plotdata2.*abs(mask);
%%
figure
newplotdata = plotdata-plotdata2;
newplotdata(newplotdata==0)=nan;
shower_tile_plot(newplotdata);
colorbar
yticks(1.5:1:65.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('Regular-Irregular','FontSize',16)

clear plot* new*
%% Plot the overall results

res =First_Results.Cond_res; % what results you want to plot
LV = 1;% What LV you want to plot
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
colormap(rgb)
clim([-6 6])
colorbar
xticks(5:5:40)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))     
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

mask = plotdata;
mask(mask>0) = 1;
mask(mask<0) = -1;
mask(mask==0) = nan;
clear res LV p xlabs K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 

%% Plot the indata as images: All data
xlabs = {'Reg Prime' ,'Irreg Prime','S1','S1',...
    'S2','S2'};
start = 1;
figure
mask(isnan(mask)) = 0;
for i = [1,3,5,2,4,6]
    plotdata = indata_all(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = plotdata.*abs(mask);
    subplot(3,2,i)
    imagesc(plotdata)
    %colormap(parula)
    colormap(flipud(rgb(1:11,:)))%
    clim([0 0.6])
    grid on
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% Plot the indata as images: All data
xlabs = {'Reg Prime' ,'Irreg Prime','S1','S1',...
    'S2','S2'};
start = 1;
mask(isnan(mask)) = 0;

for i = [1,3,5,2,4,6]
    figure
    plotdata = indata_all(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = plotdata.*abs(mask);
    %subplot(3,2,i)
    shower_tile_plot(plotdata);
    %colormap(parula)
    colormap(flipud(rgb(1:11,:)))%
    clim([0 0.6])
    grid on
    yticks(1.5:64.5)
    yticklabels(flipud(First_Results.Labels))
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% This was hard to see, so let's subtract one from the other to bring 
% out the effect:
plotdata = indata_all(1:17,:);
plotdata = mean(plotdata);
plotdata = reshape(plotdata,64,[]);
plotdata = plotdata.*abs(mask);

plotdata2 = indata_all(18:34,:);
plotdata2 = mean(plotdata2);
plotdata2 = reshape(plotdata2,64,[]);
plotdata2 = plotdata2.*abs(mask);
%%
figure
newplotdata = plotdata-plotdata2;
newplotdata(newplotdata==0)=nan;
shower_tile_plot(newplotdata);
colorbar
yticks(1.5:1:65.5)
colormap(rgb)
caxis([-0.04 0.04])
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('Prime-Sentence','FontSize',16)
%% Plot the indata as images: All data
figure
subplot(1,2,1)
shower_tile_plot(plotdata);
colormap(flipud(rgb(1:11,:)))%
clim([0 0.6])
grid on
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
xlabel('MSE Scale')
title('Prime','FontSize',16)
colorbar

subplot(1,2,2)
shower_tile_plot(plotdata2);
colormap(flipud(rgb(1:11,:)))%
clim([0 0.6])
grid on
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
xlabel('MSE Scale')
title('Sentence First Position','FontSize',16)
colorbar
%% Second Language Results:
res = First_Results.Lang2_res;
LV = 1;% What LV you want to plot
p = res.perm_result.sprob(LV);% the p-value of that LV
headline = sprintf('Sentence Res, p = %f',p);% the title with the p value
xlabs = {'Reg S1','Reg S2',...
    'Irreg S1','Irreg S2'};

figure
subplot(1,2,1)
z = res.boot_result.orig_usc;
limit = length(z);
bar(z(:,LV))
hold on
yneg = res.boot_result.llusc(1:limit,LV);
ypos = res.boot_result.ulusc(1:limit,LV);
errorbar(1:length(z(1:limit,LV)),z(1:limit,LV),yneg-z(1:limit,LV),ypos-z(1:limit,LV),'.')
grid on
xlim([0 length(z)+1])
xticks(1:length(z))
xticklabels(xlabs)
xtickangle(45)
title(headline,'FontSize',16)

x = (res.boot_result.compare_u(:,LV));
x(abs(x)<2.5) = nan;
plotdata = reshape(x,[],40);
subplot(1,2,2)
shower_tile_plot(plotdata);
colormap(First_Results.rgb)
clim([-5 5])
colorbar
xticks(5:5:40)
yticks(1.5:64.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrodes')
xlabel('MSE Scale')
title(sprintf('MSE Matrix LV %d',LV),'FontSize',16)

mask = plotdata;
mask(mask>0) = 1;
mask(mask<0) = -1;
mask(mask==0) = nan;

clear res LV p K limit ypos yneg ans x z plotdata headline
% Now we're getting somewhere! 
%% Plot the indata as images: Sentences

start = 1;
figure
mask(isnan(mask)) = 0;
for i = 1:4
    plotdata = indata_sentence(start:start+16,:);
    plotdata = mean(plotdata);
    plotdata = reshape(plotdata,64,[]);
    plotdata = plotdata.*abs(mask);
    subplot(2,2,i)
    shower_tile_plot(plotdata);
    %imagesc(plotdata)
    %colormap(parula)
    colormap(flipud(rgb(1:11,:)))%
    clim([0 0.8])
    grid on
    yticks(1.5:1:65.5)
    yticklabels(flipud(First_Results.Labels))
    ylabel('Electrode')
    xlabel('MSE Scale')
    title(xlabs{i},'FontSize',16)
    start = start+17;
    colorbar
end
clear i start
%% This was hard to see, so let's subtract one from the other to bring 
% out the effect:
plotdata = indata_sentence(1:17,:);
plotdata = mean(plotdata);
plotdata = reshape(plotdata,64,[]);
plotdata = plotdata.*abs(mask);

plotdata2 = indata_sentence(18:34,:);
plotdata2 = mean(plotdata2);
plotdata2 = reshape(plotdata2,64,[]);
plotdata2 = plotdata2.*abs(mask);

plotdata3 = indata_sentence(35:51,:);
plotdata3 = mean(plotdata3);
plotdata3 = reshape(plotdata3,64,[]);
plotdata3 = plotdata3.*abs(mask);

plotdata4 = indata_sentence(52:68,:);
plotdata4 = mean(plotdata4);
plotdata4 = reshape(plotdata4,64,[]);
plotdata4 = plotdata4.*abs(mask);
%%
plotS1 = mean(cat(3,plotdata,plotdata3),3);
plotS2 = mean(cat(3,plotdata2,plotdata4),3);

plotreg = mean(cat(3,plotdata,plotdata2),3);
plotirreg = mean(cat(3,plotdata3,plotdata4),3);

%% For LV 1
figure
newplotdata = plotS1-plotS2;
newplotdata(newplotdata==0)=nan;
newplotdata(newplotdata>0) = 1;
newplotdata(newplotdata<0) = -1;
shower_tile_plot(newplotdata);
colormap(rgb)
clim([-1 1])
colorbar
yticks(1.5:1:65.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('S1 - S2','FontSize',16)

%% For LV 2
figure
newplotdata = plotreg-plotirreg;
newplotdata(newplotdata==0)=nan;
newplotdata(newplotdata>0) = 1;
newplotdata(newplotdata<0) = -1;
shower_tile_plot(newplotdata);
colormap(rgb)
clim([-0.05 0.05])
colorbar
yticks(1.5:1:65.5)
yticklabels(flipud(First_Results.Labels))
ylabel('Electrode')
title('Regular - Irregular','FontSize',16)

clear new* %plot* 
