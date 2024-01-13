%% Step 1: get the data!
%addpath(genpath('fieldtrip-master'))
PPC_Data = cell(17,1);% pre-allocate the cell
sub_dex = [1:16,18];% 17 subjects, missing #17

for i = 1:length(PPC_Data)
    tempsub = num2str(sub_dex(i));% get the number, convet it into a string
    tempfile = strcat('MARCS/Preproc/Suj',tempsub,...
        '/Suj',tempsub,'_preproc.fif');% get the file path
    tempdata = ft_read_data(tempfile);% read in the file path
    PPC_Data{i} = tempdata;% put it in the array
    disp(i)% tell us where we are 
end% NEXT!

clear i temp* %make look nice
%% Step 2: get the triggers!
PPC_Triggers = cell(17,1);% pre-allocate the cell
sub_dex = [1:16,18];% 17 subjects, missing #17

for i = 1:length(PPC_Triggers)
    tempsub = num2str(sub_dex(i));% get the number, convet it into a string
    tempfile = strcat('MARCS/Triggers/Suj',tempsub,...
        '_events250.csv');% get the file path
    tempdata = readmatrix(tempfile);% read in the file path
    tempidx = any((tempdata == 999)|(isnan(tempdata)),2);%get rid of the nan rows
    tempdata(tempidx,:) = [];
    PPC_Triggers{i} = tempdata;% put it in the array
    disp(i)% tell us where we are 
end% NEXT!

clear i temp* %make look nice
%% 
EEG_Task = cell(144,length(PPC_Triggers));

for part = 1:length(PPC_Triggers)
    tempcell = PPC_Data{part};
    tempempty = cell(192,1);
    start_dex = PPC_Triggers{part}(:,2);
    trigger_dex= PPC_Triggers{part}(:,4);
    for i = 1:length(start_dex)
        start = start_dex(i);
        if i+1>length(start_dex)
            stop = length(tempcell);
        else
            stop = start_dex(i+1);
        end
        tempdata = tempcell(1:64,start:stop);%need to remove 250 indices
        tempempty{i} = tempdata;
        %EEG_Task{i,part} = tempdata;
    end
    tempempty(trigger_dex==250)=[];
    EEG_Task(:,part) = tempempty;
end
clear part i temp* start stop
% %% Downsample the data 
% % Downsampling with fieldtrip
% 
% cfg.resamplefs = 256;
% cfg.method = 'downsample';
% cfg.detrend = 'no';
% cfg.demean = 'no';
% cfg.baselinewindow = [1 120];
% cfg.feedback = 'text';
% cfg.trials = 'all';
% cfg.sampleindex = 'no';
% 
% data = data_ica_clean_S1{1};
% test_ds = ft_resampledata(cfg,data);
%% Start here with the QC!
%% MSE it!
K = 64;
m = 2;% default
r =0.5;% default
scales = (1:40);% default is 40
MSE_Task = cell(size(EEG_Task));
for part = 1:size(EEG_Task,2)
    tempcell = EEG_Task(:,part);
    parfor cond = 1:length(EEG_Task)
        temp = tempcell{cond};
        temp(isnan(temp)) = 0;
        mse_temp = get_multiple_mse_curves_matlab(temp',m,r,scales,0);
        MSE_Task{cond,part} = mse_temp';
        disp(cond)
    end
    disp(strcat('Participant ',num2str(part),' is done, your highness!'))
end

%% Let's do some quality control!

EEG_FCs = cell(size(EEG_Task));

for part = 1:17
    for task = 1:144
        tempdata = EEG_Task{task,part};
        tempcorr = corrcoef(tempdata');
        EEG_FCs{task,part} = tempcorr;
    end
end
clear part task temp*
%% Onto STATIS
addpath(genpath('Pls'))
EEG_Sims = cell(17,1);
for part = 1:17
    tempdata = EEG_FCs(:,part);
    tempdata = cat(3,tempdata{:});
    tempres = distatis2(tempdata);
    EEG_Sims{part} = tempres.C;
end
clear part temp*
%%
figure
for part = 1:17
    plotdata = EEG_Sims{part};
    subplot(4,5,part)
    imagesc(plotdata);
    caxis([0 1])
    colorbar
    xticks([])
    yticks([])
    title(sprintf('Participant %d',part),'FontSize',16)
end
clear part
%% New Triggers without the 250s!
Task_trigs = cell(size(PPC_Triggers));

for part = 1:length(Task_trigs)
    temptrigs = PPC_Triggers{part}(:,4);
    temptrigs(temptrigs==250) = [];
    Task_trigs{part} = temptrigs;
end
clear part temp*
%%
MARCS_vars.Raw_trigs = PPC_Triggers;
MARCS_vars.Task_trigs = Task_trigs;
MARCS_vars.MSE_Task = MSE_Task;