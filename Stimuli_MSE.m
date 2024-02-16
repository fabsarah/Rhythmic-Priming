%% Step 1: get the data!
addpath(genpath('MARCS'))
R_Reg = cell(6,2);% pre-allocate the cell
R_Irreg = cell(6,2);
Sentence = cell(96,2);

% Regular Audio 
cd MARCS/Rhythms_Reg
tempdir = dir('*.wav');
for i = 1:length(tempdir)
    [y, ~] = audioread(tempdir(i).name);
    [yupper,~] = envelope(y(:,1));
    R_Reg{i} = yupper;
end
R_Reg(:,2) = {tempdir.name};
clear i y temp* yup*
cd ..
cd ..

% Irregular Audio 
cd MARCS/Rhythms_Irreg
tempdir = dir('*.wav');
for i = 1:length(tempdir)
    [y, ~] = audioread(tempdir(i).name);
    [yupper,~] = envelope(y(:,1));
    R_Irreg{i} = yupper;
end
R_Irreg(:,2) = {tempdir.name};
clear i y temp*  yup*
cd ..
cd ..

% Sentences 
cd MARCS/Sentences
tempdir = dir('*.wav');
for i = 1:length(tempdir)
    [y, ~] = audioread(tempdir(i).name);
    [yupper,~] = envelope(y(:,1));
    Sentence{i} = yupper;
end
Sentence(:,2) = {tempdir.name};
clear i y temp* yup*
cd ..
cd ..
%% Resampling
% audio Fs is: 44100
% target Fs is 250
Fs = 44100;
Fs_new = 250;

for i = 1:length(R_Irreg)
    temp_reg = R_Reg{i,1};
    temp_irreg = R_Irreg{i,1};
    R_Reg{i,3} = resample(temp_reg,Fs_new,Fs);
    R_Irreg{i,3} = resample(temp_irreg,Fs_new,Fs);
end
clear temp* i

for i = 1:length(Sentence)
    temp_sent = Sentence{i,1};
    Sentence{i,3} = resample(temp_sent,Fs_new,Fs);
end
clear i temp*
%% MSE
tempmat = cell(108,1);
tempdata = [R_Reg(:,3);R_Irreg(:,3);Sentence(:,3)];

stim_mse = nan(length(tempdata),40);

for i = 1:length(tempdata)
    tempvec = tempdata{i};
    tempmse = get_multiple_mse_curves_matlab(tempvec,2,0.5,(1:40),0);
    stim_mse(i,:) = tempmse;
end
disp('Il tuo codice ha finito, dottoressa')

clear i temp*
%% Plot some curves!
plotreg = mean(stim_mse(1:6,:));
plotirreg = mean(stim_mse(7:12,:));
plotsent = mean(stim_mse(13:end,:));

plotdata = [plotreg;plotirreg;plotsent];
figure
plot(plotdata','LineWidth',2)
grid on
legend({'Regular','Irregular','Sentence'},'FontSize',14)
title('Averaged MSE Curves: Stimuli','FontSize',16)

clear plot*

%%
figure
subplot(1,3,1)
plot(stim_mse(1:6,:)','LineWidth',2)
grid on
%legend({'Regular','Irregular','Sentence'},'FontSize',14)
title('MSE Curves: Regular Rhythms','FontSize',16)

subplot(1,3,2)
plot(stim_mse(7:12,:)','LineWidth',2)
grid on
%legend({'Regular','Irregular','Sentence'},'FontSize',14)
title('MSE Curves: Irregular Rhythms','FontSize',16)

subplot(1,3,3)
plot(stim_mse(13:end,:)','LineWidth',2)
grid on
%legend({'Regular','Irregular','Sentence'},'FontSize',14)
title('MSE Curves: Sentences','FontSize',16)



%% Old Stuff
% Music pieces were imported into Matlab using the wavread function at a 
% sampling rate of 11.25 kHz (MathWorks, Inc., Release 2011b). Music 
% auditory signal MSE was subsequently calculated with the same parameter 
% values and the same number of timescales as the EEG source MSE.

%wavread appears to be legacied now, and we have audio read! Let's try it!

[~, Fs] = audioread('MARCS/Rhythms_Reg/01_R2b_stereoeq.wav');
% gives is a 2*Fs matrix of numbers. I think its's stereo...both columns
% are equal so far. 
%%
[yupper,~] = envelope(y);
%%
data = yupperw(1:172:end,1);
test = get_multiple_mse_curves_matlab(data,2,0.5,(1:40),0);
%%
num_cg_tpts = floor(size(data,1)/2);
sc = 2;
z = zeros(size(data,1), 1);
y = zeros(num_cg_tpts, 1);
for t = 1:num_cg_tpts
y(t,:) = mean(data((t-1)*sc + [1:sc],:),1);
end 