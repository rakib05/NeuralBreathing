coh_results_Path = '.\saved_results\';
addpath(genpath('.\reqfunc\'));
% load saved coherence results
dataAw = load([coh_results_Path,'CohAwakeBiPolar.mat']);
dataAnes = load([coh_results_Path,'CohAnesBiPolar.mat']);
dataVS = load([coh_results_Path,'CohVentBiPolar.mat']);
dataSLP = load([coh_results_Path,'CohSleepBiPolar.mat']);

%% define colors
color_aw = [0.1 0.7 0];
colorSleep = [0.9 0.4 0.1];
color_sp = [0 0.6 0.8];
color_vs = [0.6 0.12 0.47];
colorS = [color_aw;colorSleep;color_sp;color_vs];
Fs = 500; % sampling rate all blocks except sleep
Fs_slp = 250; % sampling rate for sleep data

% some plotting variables to define
pThr = 0.05;
Msize = 80;
Csize = [50,180];
templateAlpha = 0.09;
Malpha = 0.9;
BrHem = 1;
% find significant indexes
% get significant contacts indexes
awakeIndx = dataAw.significance_v;
anesIndx = dataAnes.significance_v;
ventsIndx = dataVS.significance_v;
sleepIndx = dataSLP.significance_v;
%% Figure 1: Plot coverage and Coherence for each patient
Msize = 35;
Csize = [50,180]; BrainAlpha = 0.3; BrainColor = [1 0.98 0.98];
unqPt = unique(dataAw.ptID);
for j = 1:length(unqPt)
    close all;
    plotPatientBrain(unqPt(j),BrHem,BrainAlpha,BrainColor,[]); % plot the template brain LH on right, RH on left hemReverse=true
    h = gca; h.ZAxis.Visible = 'off'; light('position', [-30000 0 0]);
    set(gcf, 'Position',  [100, 100, 590, 600]); % for lateral view
    AwCord = dataAw.ChnCoordinates(dataAw.ptID==unqPt(j),:); % locIndx_aw from later section to plot only GM contacts
    h1=scatter3(AwCord(:,1), AwCord(:,2),AwCord(:,3), Msize.*ones(size(AwCord,1),1),...
        MarkerFaceColor = [0.4 0.4 0.4],MarkerFaceAlpha = Malpha,MarkerEdgeColor=[0.1 0.1 0.1]);
    axx = gca; 
    camlight('headlight');
    zlim([-60 95]);
    view([0 0 90]); % Axial 
    %view([0 -90 0]); % coronal view
    %view([-90 0 0]); % lateral view
    tmpVal = dataAw.CohValue(dataAw.ptID==unqPt(j));
    tmpcoord = dataAw.ChnCoordinates(dataAw.ptID==unqPt(j),:);
    tmpindx = awakeIndx(dataAw.ptID==unqPt(j));
    plotPatientscatter(unqPt(j),tmpcoord, tmpindx,tmpVal,BrHem,BrainAlpha,Csize,color_aw,Malpha,BrainColor,false);
    camlight('headlight');
    h = gca; h.ZAxis.Visible = 'off';
    zlim([-60 95]);
    view([0 0 90]); % Axial 
    % plot patient brain surf
    plotPatientBrain(unqPt(j),BrHem,0.92,[0.92 0.92 0.92],[],false);
    %camlight('headlight','infinite');
    delete(findall(gcf,'Type','light'));
    light('position', [0 0 900000]); %light('position', [0 -300000 0])
    material dull; 
    h = gca; h.YAxis.Visible = 'off';
    fig = gcf; % Get the current figure handle
    set(fig, 'Name',num2str(unqPt(j)) , 'NumberTitle', 'off');
    fprintf('Patient: %d\n',unqPt(j))
    % plot respiration data
    tt = (1:length(dataAw.tsData(j).belt))./Fs;
    figure('Position',[200 200 750 280],'Color','w');
    plot(tt,zscore(dataAw.tsData(j).belt),'color',[0.4,0.4,0.4],'LineWidth',1.6);
    xlim([50 30+55]); 
    ylim([-2.9 2.9]);
    yticks([-2,-1,0,1,2]);
    set(gca,'FontSize',25);
    [Pbb,pF] = plotPSD(dataAw.tsData(j).belt,Fs,50,0,2^19,'n');
    [~,mxIn] = max(Pbb);
    Resfreq(j) = pF(mxIn);
    box off; title(sprintf(['%d: f = %0.2fHz'], unqPt(j),Resfreq(j) ));

    h = gca; h.XAxis.Visible = 'off';
end
% Plot sagittal Left and Right 
fprintf('Plotting: Lateral views........\n');
Msize = 35; Csize = [50,180];
unqPt = unique(dataAw.ptID);
for j = 1:length(unqPt)
    %close all;
    tmpVal = dataAw.CohValue(dataAw.ptID==unqPt(j));
    tmpcoord = dataAw.ChnCoordinates(dataAw.ptID==unqPt(j),:);
    tmpindx = awakeIndx(dataAw.ptID==unqPt(j));
    plotPatientSagittal(unqPt(j),tmpcoord, tmpindx,tmpVal,BrainAlpha,Csize,color_aw,Malpha,BrainColor,0);
    fprintf('Patient: %d\n',unqPt(j));
end 

%% plot coverage during Awake States and Coherence on template Brain
% plot Coverage
hemRev = false; % plot the template brain LH on right, RH on left
plotBrainPatch(BrHem,templateAlpha,[],[], hemRev); 
% plot Significant contacts in Awake breathing
awCord = dataAw.ChnCoordinates;
h1=scatter3(awCord(:,1),awCord(:,2),awCord(:,3), Msize.*ones(size(awCord,1),1)./2, [0.3 0.3 0.3],'fill');
h1.MarkerFaceAlpha = Malpha;
axx = gca;
% Create line
view([0 0 90]);
material metal;
camlight(axx, 'headlight');
set(gcf,'Name','Coverage Map: Awake Fig3B, Anesthetized Fig5B, Ventilated Fig6B','NumberTitle', 'off');
%BrainColor = [0.78 0.7 0.7];

%
BrainAlpha = 0.3; BrainColor = [1 0.98 0.98];
plotbrainscatter(dataAw,awakeIndx,dataAw.CohValue,BrHem,BrainAlpha,Csize,color_aw,Malpha,BrainColor)
set(gcf,'Name','Coherence Map: Awake Fig3C','NumberTitle', 'off');
plotbrainscatter(dataAw,awakeIndx,dataAw.CohValue,BrHem,BrainAlpha,Csize,color_aw,Malpha,BrainColor,true)
set(gcf,'Name','Coherence Map: Awake Fig3C','NumberTitle', 'off');
% plot coverage during Sleep States and Coherence on template Brain
plotBrainPatch(BrHem,templateAlpha,[],[]); % plot the template brain LH on right, RH on left
% plot Significant contacts in Awake breathing
slpCord = dataSLP.ChnCoordinates; % locIndx_aw from later section to plot only GM contacts
h1=scatter3(-slpCord(:,1), slpCord(:,2),slpCord(:,3), Msize.*ones(size(slpCord,1),1)./2,[0.3 0.3 0.3],'fill');
h1.MarkerFaceAlpha = Malpha;
axx = gca;
% Create line
view([0 0 90]);
camlight(axx, 'headlight');
set(gcf,'Name','Coverage Map: Sleep Fig4B','NumberTitle', 'off');
% plot coherence
plotbrainscatter(dataSLP,sleepIndx,dataSLP.CohValue,BrHem,BrainAlpha,Csize,colorSleep,Malpha,BrainColor)
set(gcf,'Name','Coherence Map: Sleep Fig4C','NumberTitle', 'off');

% plot Coherence on template Brain: Anesthesia and mechanical ventilation
plotbrainscatter(dataAnes,anesIndx,dataAnes.CohValue,BrHem,BrainAlpha,Csize,color_sp,Malpha,BrainColor);
set(gcf,'Name','Coherence Map: Anesthetized Fig5C','NumberTitle', 'off');
plotbrainscatter(dataAnes,anesIndx,dataAnes.CohValue,BrHem,BrainAlpha,Csize,color_sp,Malpha,BrainColor,true);
set(gcf,'Name','Coherence Map: Anesthetized Fig5C','NumberTitle', 'off');
% mechanical ventilation
plotbrainscatter(dataVS,ventsIndx,dataVS.CohValue,BrHem,BrainAlpha,Csize,color_vs,Malpha,BrainColor);
set(gcf,'Name','Coherence Map: Ventilated Fig6C','NumberTitle', 'off');
plotbrainscatter(dataVS,ventsIndx,dataVS.CohValue,BrHem,BrainAlpha,Csize,color_vs,Malpha,BrainColor,true);
set(gcf,'Name','Coherence Map: Ventilated Fig6C','NumberTitle', 'off');
%% ROIbased scatter plots
roiscatterplot(dataAw.CohValue,dataAw.LocationsKN,color_aw,[0,1]);
set(gcf,'Name','Fig3H Awake Breathing-LFP coherence','NumberTitle', 'off');

roiscatterplot(dataSLP.CohValue,dataSLP.LocationsKN,colorSleep,[0,0.8]);
set(gcf,'Name','Fig4D Sleep Breathing-LFP coherence','NumberTitle', 'off');

roiscatterplot(dataAnes.CohValue,dataAnes.LocationsKN,color_sp,[0,1]);
set(gcf,'Name','Fig5D Anesthetized automatic Breathing-LFP coherence','NumberTitle', 'off');

roiscatterplot(dataVS.CohValue,dataVS.LocationsKN,color_vs,[0,0.8]);
set(gcf,'Name','Fig5D Anesthetized ventilated Breathing-LFP coherence','NumberTitle', 'off');

%% summary stats
dataList = {dataAw, dataSLP, dataAnes, dataVS};
stateNames = {'Awake', 'Sleep', 'Anesthetized','Ventilation'};

for d = 1:length(dataList)
    data = dataList{d};
    state = stateNames{d};

    sigIndx = data.significance_v;
    ptIDs   = unique(data.ptID);

    nSite = zeros(length(ptIDs), 1);
    nSigf = zeros(length(ptIDs), 1);

    for ii = 1:length(ptIDs)
        nSite(ii) = sum(data.ptID == ptIDs(ii));
        nSigf(ii) = sum(sigIndx(data.ptID == ptIDs(ii)));
    end

    totalSites = sum(nSite);
    totalSigf  = sum(nSigf);

    meanSitesPerPt = mean(nSite);
    stdSitesPerPt  = std(nSite);

    meanSigfPerPt = mean(nSigf);
    stdSigfPerPt  = std(nSigf);

    percentSigf = (totalSigf / totalSites) * 100;

    % Print for this state
    fprintf('\n=== %s ===\n', state);
    fprintf('Total sites: %d\n', totalSites);
    fprintf('Total significant sites: %d\n', totalSigf);
    fprintf('Sites per participant: %.1f ± %.1f\n', meanSitesPerPt, stdSitesPerPt);
    fprintf('Significant sites per participant: %.1f ± %.1f\n', meanSigfPerPt, stdSigfPerPt);
    fprintf('Overall percentage of significant sites: %.1f%%\n', percentSigf);
end

%% Coherence in each ROI bar plot
awValues = dataAw.CohValue; slpValues = dataSLP.CohValue;
spValues = dataAnes.CohValue; vsValues = dataVS.CohValue;

LocOR = roiNameUpdate(dataAw.LocationsKN);
LocSLP = roiNameUpdate(dataSLP.LocationsKN);

% unique ROIs
unqROI = unique([LocOR;LocSLP]);
Nroi = length(unqROI);
CountsROI = zeros(Nroi, 2); countsS = zeros(Nroi, 4);

vioData = cell(Nroi,4);
for kk = 1:Nroi
    indxAW = strcmp(LocOR, unqROI{kk});
    indxSLP = strcmp(LocSLP, unqROI{kk});
    CountsROI(kk,1) = sum(indxAW);%sum(cell2mat(strfind(Loc, uniqLoc{kk})));
    CountsROI(kk,2) = sum(indxSLP);
    countsS(kk,1) = sum(strcmp(LocOR(awakeIndx), unqROI{kk}));
    countsS(kk,2) = sum(strcmp(LocSLP(sleepIndx), unqROI{kk}));
    countsS(kk,3) = sum(strcmp(LocOR(anesIndx), unqROI{kk}));
    countsS(kk,4) = sum(strcmp(LocOR(ventsIndx), unqROI{kk}));
    vioData{kk,1} = awValues(indxAW)';
    vioData{kk,2} = slpValues(indxSLP)';
    vioData{kk,3} = spValues(indxAW)';
    vioData{kk,4} = vsValues(indxAW)';
end
% remove ROIs less than 5 total contacts
rmvIndx = find(CountsROI(:,1)<=5);
CountsROI(rmvIndx,:)=[];
countsS(rmvIndx,:)=[];
unqROI(rmvIndx)=[];
vioData(rmvIndx,:) = [];

roiInx = sortROI(unqROI);

CountsROI = CountsROI(roiInx,:);
countsS = countsS(roiInx,:);
unqROI = unqROI(roiInx);
vioData = vioData(roiInx,:);
roiPercentage = 100*([countsS(:,1)./CountsROI(:,1),countsS(:,2)./CountsROI(:,2),countsS(:,3:4)./CountsROI(:,1)]);
% find empty cells in vioData
isEmptyCell = cellfun(@isempty, vioData);
[vioData{isEmptyCell}] = deal(NaN); % filling NaN values on empty cells

meanCorr = cell2mat(cellfun(@mean, vioData, 'UniformOutput', false));
stdCorr = cell2mat(cellfun(@std, vioData, 'UniformOutput', false));


% Compare coherence during Awake vs Sleep across participants
AwakeVal = [];
SleepVal = [];
nPt = unique(dataAw.ptID);

for i = 1:length(nPt)
    IndxAwake = dataAw.ptID == nPt(i);
    IndxSleep = dataSLP.ptID == nPt(i);

    % Mean coherence per participant in each state
    if ~isnan(mean(dataSLP.CohValue(IndxSleep)))
        SleepVal = [SleepVal; mean(dataSLP.CohValue(IndxSleep))];
    end
    if ~isnan(mean(dataAw.CohValue(IndxAwake)))
        AwakeVal = [AwakeVal; mean(dataAw.CohValue(IndxAwake))];
    end
end

% Statistical Comparison
% Wilcoxon Rank-Sum test
[p_slp_awake, ~, stats] = ranksum(AwakeVal, SleepVal);

% Rank-biserial correlation effect size
ranksumU = stats.ranksum;
nAw = numel(AwakeVal);
nSlp = numel(SleepVal);
U = stats.ranksum - nAw*(nAw+1)/2;  % convert from W to U
rankBiserial = (2*U)/(nAw * nSlp) - 1; % effect size
% Medians and IQRs
AwakeMedian = median(AwakeVal);
AwakeIQR = iqr(AwakeVal);
SleepMedian = median(SleepVal);
SleepIQR = iqr(SleepVal);

fprintf('\n--- Statistical Summary (Awake vs Sleep) ---\n');
fprintf('Wilcoxon rank-sum test: p = %.4f\n', p_slp_awake);
fprintf('Rank-biserial correlation: %.2f\n', rankBiserial);
fprintf('Awake: median = %.3f, IQR = %.3f\n', AwakeMedian, AwakeIQR);
fprintf('Sleep: median = %.3f, IQR = %.3f\n', SleepMedian, SleepIQR);

% Violin Plot
mxLen = max([length(AwakeVal), length(SleepVal)]);
vio_aw = [AwakeVal; NaN(mxLen-length(AwakeVal),1)];
vio_slp = [SleepVal; NaN(mxLen-length(SleepVal),1)];
violinData = [vio_aw, vio_slp];

figure("Position", [200, 100, 400, 350]);
vp = violinplot(violinData, {'Awake', 'Sleep'}, ...
    'ViolinColor', brighten(colorS, 0.4), 'Width', 0.2, 'ShowMean', true);

for ii = 1:length(vp)
    mmColor = brighten(colorS(ii,:), -0.6);
    vp(ii).MeanPlot.Color = mmColor;
    vp(ii).MeanPlot.LineWidth = 2;
    vp(ii).MedianColor = [1, 1, 1];
    vp(ii).MedianPlot.SizeData = 100;
end

ylim([0 0.45]);
ylabel('Coherence (R)')
box off;
xlim([0.5 2.5]);
set(gcf, 'color', 'w');
axx = gca;
axx.YTick = [0:0.2:1];
set(axx, 'fontSize', 16);
set(gcf,'Name','Awake vs. Sleep: Fig4E');
% compute where to place the text
ymax = max([AwakeVal; SleepVal]);
% display the exact p-value
text(1.5, ymax*1.3, sprintf('p = %.4f', p_slp_awake), ...
    'HorizontalAlignment','center', 'FontSize',14);

% plot awake vs sleep
% unique ROIs
sleepROI = unique([LocOR;LocSLP]);
Nroi = length(sleepROI);
sleepROIcount = zeros(Nroi, 1);
for kk = 1:Nroi
    indxSLP = strcmp(LocSLP, sleepROI{kk});
    sleepROIcount(kk) = sum(indxSLP);
end
% remove ROIs less than 5 total contacts
rmvIndx = find(sleepROIcount(:,1)<=5);
sleepROIcount(rmvIndx,:)=[];
sleepROI(rmvIndx)=[];

roiInx = sortROI(sleepROI);
sleepROIcount = sleepROIcount(roiInx);
sleepROI = sleepROI(roiInx);

awake_sleep_LME = plotLME(sleepROI,dataAw,dataSLP,awakeIndx,sleepIndx,color_aw,colorSleep,{'Awake','Sleep'});
ylim([0 0.38]);
set(gcf,'Name','Awake vs. Sleep LME: Fig4F');

%% compare states Spont vs vents
spontVal = [];
ventVal = [];
nPt = unique(dataAnes.ptID);
for i = 1:length(nPt)
    IndxSpont = dataAnes.ptID ==nPt(i);
    IndxVent = dataVS.ptID ==nPt(i);
    if ~isnan(mean(dataAnes.CohValue(IndxSpont)))
        spontVal = [spontVal;mean(dataAnes.CohValue(IndxSpont))];
    end
    if ~isnan(mean(dataAw.CohValue(IndxVent)))
        ventVal = [ventVal;mean(dataVS.CohValue(IndxVent))];
    end
end

% Wilcoxon signed-rank test for paired samples
[p_sp_vs, ~, stats] = signrank(spontVal, ventVal);

% Rank-biserial correlation (paired samples)
% r = (number of positive - number of negative differences) / total pairs
diffSigns = sign(spontVal - ventVal);
rankBiserial = sum(diffSigns) / numel(diffSigns);

% Medians and IQRs
SpontMedian = median(spontVal);
SpontIQR = iqr(spontVal);
VentMedian = median(ventVal);
VentIQR = iqr(ventVal);

fprintf('\n--- Statistical Summary (Spontaneous vs Ventilation, Paired) ---\n');
fprintf('Wilcoxon signed-rank test: p = %.4f\n', p_sp_vs);
fprintf('Rank-biserial correlation: %.2f\n', rankBiserial);
fprintf('Spontaneous: median = %.3f, IQR = %.3f\n', SpontMedian, SpontIQR);
fprintf('Ventilation: median = %.3f, IQR = %.3f\n', VentMedian, VentIQR);

mxLen = max([length(spontVal),length(ventVal)]);
vio_sp = [spontVal;NaN(mxLen-length(spontVal),1)];
vio_vs = [ventVal;NaN(mxLen-length(ventVal),1)];

%violinData = [vio_aw,vio_slp, vio_sp,vio_vs];
violinData = [vio_sp, vio_vs];

figure("Position",[200,100,700,550]);
vp = violinplot(violinData,{'Anesthetized','Ventilated'},...
    'ViolinColor',brighten(colorS(3:4,:),0.4),'Width',0.2,'ShowMean',true); %'ShowBox',false,'ShowMedian',false);
for ii = 1:length(vp)
    mmColor = brighten(colorS(2+ii,:),-0.6);
    vp(ii).MeanPlot.Color = mmColor;
    vp(ii).MeanPlot.LineWidth = 2;
    vp(ii).MedianColor = [1,1,1];
    vp(ii).MedianPlot.SizeData = 100;
end

ylim([0 0.45]);
ylabel('Coherence (R)')
box off;
xlim([0.5 2.5]);
set(gcf, 'color', 'w');
axx = gca;
axx.YTick = [0:0.2:1];
set(axx, 'fontSize', 16);

% hh = sigstar({[1 2]}, p_sp_vs, 0);
% set(hh(:,2), 'FontSize', 20);
% compute where to place the text
ymax = max([spontVal; ventVal]);
% display the exact p-value
text(1.5, ymax*1.3, sprintf('p = %.3f', p_sp_vs), ...
    'HorizontalAlignment','center', 'FontSize',14);
% plot spont vs vents
lme_anes_vent = plotLME(unqROI,dataAnes,dataVS,anesIndx,ventsIndx,color_sp,color_vs,{'Anesthetized','Ventilated'});
ylim([0 0.38]);
set(gcf,'Name','Anethetized vs. Ventilated LME: Fig6E');

%% slow-deep breathing 
clear
addpath(genpath('.\reqfunc\'));
roundM = @(x,m) round(x*10^m)./10^m;
dataVHi = load('.\saved_results\CohVentHi.mat'); % load saved results for high-tidal volume ventilation
dataVS = load('.\saved_results\CohVent_matchedHiTV.mat'); % load saved results for mathed ventilation (5 Part)
% define colors
color_vs = [0.6 0.12 0.47];
color_vHi = [0 0.5 0.3]; %[0.2 0.9 0.8];
colorS = [color_vs;color_vHi];
Fs = 500;
% some used variables to define
pThr = 0.05;
Msize = 70;
Csize = [50,180];
templateAlpha = 0.09;
BrainAlpha = 0.3;
Malpha = 0.9;
BrHem = 1;
% significant contact indexes
ventsIndx = dataVS.significance_v;
ventHiIndx = dataVHi.significance_v;
%plot coverage during Awake States and Correlations on template Brain
% plot Coverage
plotBrainPatch(BrHem,templateAlpha,[],[],true); % plot the template brain LH on right, RH on left
% plot Significant contacts in Awake breathing
vHiCord = dataVHi.ChnCoordinates; % Brain sites MNI coordinates
h1=scatter3(-vHiCord(:,1),vHiCord(:,2),vHiCord(:,3),Msize.*ones(size(vHiCord,1),1)./2,...
    MarkerFaceColor = [0.4 0.4 0.4],MarkerFaceAlpha = Malpha,MarkerEdgeColor=[0.1 0.1 0.1]);
axx = gca;
% Create line
view([0 0 90]);
camlight(axx, 'headlight');
set(gcf,'Name','Coverage Map: Slow-deep Fig7A','NumberTitle', 'off');

% plot coherence on template brain
dataVS.ChnCoordinates = dataVHi.ChnCoordinates;
ventsIndx(dataVS.CohValue< 0.1)=0;
BrainColor = [1 0.98 0.98];

plotbrainscatter(dataVS,ventsIndx,dataVS.CohValue,BrHem,BrainAlpha,Csize,color_vs,Malpha,BrainColor);
set(gcf,'Name','Coherence: Standard Fig7B','NumberTitle', 'off');

plotbrainscatter(dataVHi,ventHiIndx,dataVHi.CohValue,BrHem,BrainAlpha,Csize,color_vHi,Malpha,BrainColor)
set(gcf,'Name','Coherence: Slow-deep Fig7C','NumberTitle', 'off');
%
conds = {"VentS","VentHi"}; 
% Common participants present in both conditions
commonPt = sort(intersect(unique(dataVS.ptID(:)), unique(dataVHi.ptID(:))));

ratioVS  = nan(numel(commonPt),1);
ratioVHi = nan(numel(commonPt),1);

for i = 1:numel(commonPt)
    p = commonPt(i);
    ratioVS(i)  = mean(logical(dataVS.significance_v(dataVS.ptID==p)));
    ratioVHi(i) = mean(logical(dataVHi.significance_v(dataVHi.ptID==p)));
end

% Print per-participant ratios
fprintf('Per-participant proportion of significant contacts (all sites):\n');
for i = 1:numel(commonPt)
    fprintf('  %d: VentS=%.3f, VentHi=%.3f\n', commonPt(i), ratioVS(i), ratioVHi(i));
end

% One-sided paired Wilcoxon: VentHi > VentS
[p_one,~,~] = signrank(ratioVS, ratioVHi, 'tail','left');  % tests median(VentS - VentHi) < 0
fprintf('One-sided Wilcoxon (VentHi > VentS): N=%d, p=%.4g\n', numel(commonPt), p_one);


violinData = [ratioVS, ratioVHi];

figure("Position",[200,100,400,450]);
vp = violinplot(violinData,{'Standard','Slow-deep'},...
    'ViolinColor',brighten(colorS(1:2,:),0.5),'Width',0.2,'ShowMean',true); %'ShowBox',false,'ShowMedian',false);

for ii = 1:length(vp)
    mmColor = brighten(colorS(ii,:),-0.7);
    vp(ii).MeanPlot.Color = mmColor;
    vp(ii).MeanPlot.LineWidth = 2;
    vp(ii).MedianColor = [1,1,1];
    vp(ii).MedianPlot.SizeData = 100;
end

ylim([0 0.8]);
ylabel('Proportion of significant sites')
box off;
xlim([0.5 2.5]);
set(gcf, 'color', 'w');
axx = gca;
axx.YTick = 0:0.2:1;
set(axx, 'fontSize', 16);

% hh = sigstar({[1 2]}, p_one, 0);
% set(hh(:,2), 'FontSize', 20);

% display the exact p-value
ymax = max(violinData(:), [], 'omitnan');
text(1.5, ymax*1.15, sprintf('p = %.3g', p_one), ...
    'HorizontalAlignment','center', 'FontSize',14);


%% summary stats
dataList = {dataVS,dataVHi};
stateNames = {'Ventilation','Slow-deep'};

for d = 1:length(dataList)
    data = dataList{d};
    state = stateNames{d};

    sigIndx = data.significance_v;
    ptIDs   = unique(data.ptID);

    nSite = zeros(length(ptIDs), 1);
    nSigf = zeros(length(ptIDs), 1);

    for ii = 1:length(ptIDs)
        nSite(ii) = sum(data.ptID == ptIDs(ii));
        nSigf(ii) = sum(sigIndx(data.ptID == ptIDs(ii)));
    end

    totalSites = sum(nSite);
    totalSigf  = sum(nSigf);

    meanSitesPerPt = mean(nSite);
    stdSitesPerPt  = std(nSite);

    meanSigfPerPt = mean(nSigf);
    stdSigfPerPt  = std(nSigf);

    percentSigf = (totalSigf / totalSites) * 100;

    % Print for this state
    fprintf('\n=== %s ===\n', state);
    fprintf('Total sites: %d\n', totalSites);
    fprintf('Total significant sites: %d\n', totalSigf);
    fprintf('Sites per participant: %.1f ± %.1f\n', meanSitesPerPt, stdSitesPerPt);
    fprintf('Significant sites per participant: %.1f ± %.1f\n', meanSigfPerPt, stdSigfPerPt);
    fprintf('Overall percentage of significant sites: %.1f%%\n', percentSigf);
end
%scatter plot
roiscatter2states(dataVS.CohValue,dataVHi.LocationsKN,dataVHi.CohValue,dataVHi.LocationsKN,colorS);
title('Breathing-LFP coherence in ventilator driven breathing: standard and slow, deep ventilation');
set(gcf,'Name','Coherence: Fig7D','NumberTitle', 'off');

% LME for standard vs slow-deep 
vsValues = dataVS.CohValue;
vHiValues = dataVHi.CohValue;
LocVent = roiNameUpdate(dataVHi.LocationsKN);

% unique ROIs
unqROI = unique(LocVent);
Nroi = length(unqROI);
CountsROI = zeros(Nroi, 1); countsS = zeros(Nroi, 2);

vioData = cell(Nroi,2); % select number of columns (columns represent states)
for kk = 1:Nroi
    indxL = strcmp(LocVent, unqROI{kk});
    CountsROI(kk,1) = sum(indxL);%sum(cell2mat(strfind(Loc, uniqLoc{kk})));
    countsS(kk,1) = sum(strcmp(LocVent(ventsIndx), unqROI{kk}));
    countsS(kk,2) = sum(strcmp(LocVent(ventHiIndx), unqROI{kk}));
    vioData{kk,1} = vsValues(indxL)';
    vioData{kk,2} = vHiValues(indxL)';
end
% remove ROIs less than 5 total contacts
rmvIndx = find(CountsROI<=5);
CountsROI(rmvIndx,:)=[];
countsS(rmvIndx,:)=[];
unqROI(rmvIndx)=[];
vioData(rmvIndx,:) = [];

roiInx = sortROI(unqROI);

CountsROI = CountsROI(roiInx,:);
countsS = countsS(roiInx,:);
unqROI = unqROI(roiInx);
vioData = vioData(roiInx,:);
roiPercentage = 100*([countsS(:,1),countsS(:,2)]./CountsROI);
% find empty cells in vioData
isEmptyCell = cellfun(@isempty, vioData);
[vioData{isEmptyCell}] = deal(NaN); % filling NaN values on empty cells

meanCorr = cell2mat(cellfun(@mean, vioData, 'UniformOutput', false));
stdCorr = cell2mat(cellfun(@std, vioData, 'UniformOutput', false));


lme_ventHi = plotLME(unqROI,dataVS,dataVHi,ventsIndx,ventHiIndx,color_vs,color_vHi,{'standard ventilation','slow-deep ventilation'});
ylim([0 0.49]);
yticks([0:0.15:1]);
set(gcf,'Name','Coherence: Fig7F','NumberTitle', 'off');



