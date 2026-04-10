function selectedModel = plotLME(targetROI,dataS1,dataS2,sigindx_s1,sigindx_s2,colorS1,colorS2,legendTxt)

LocS1 = roiNameUpdate(dataS1.LocationsKN);
LocS2 = roiNameUpdate(dataS2.LocationsKN);
indxS1 = ismember(LocS1,targetROI);
indxS2 = ismember(LocS2,targetROI);

CohVal_S1 = dataS1.CohValue(indxS1);
CohVal_S2 = dataS2.CohValue(indxS2);

logitT = @(a) log(a./(1-a)); % Logit transform function
%legendTxt to define the State labels in the order you want
labels = string(legendTxt(:));           % e.g., ["Awake","Sleep"]
n1 = numel(CohVal_S1);
n2 = numel(CohVal_S2);

if nargin<8 || isempty(legendTxt)
    state = categorical([ones(length(CohVal_S1),1); 2.*ones(length(CohVal_S2),1)]);
else
    state = categorical([repmat(labels(1), n1, 1); repmat(labels(2), n2, 1)], labels);
end
roi = categorical([LocS1(indxS1); LocS2(indxS2)]);
subID = categorical([dataS1.ptID(indxS1); dataS2.ptID(indxS2)]);
chnNum = categorical([dataS1.chnN(indxS1); dataS2.chnN(indxS2)]);
targetVal = logitT([CohVal_S1; CohVal_S2]);
Significance = double([sigindx_s1(indxS1); sigindx_s2(indxS2)]);

lmeTable = table(subID,roi,chnNum,state,Significance,targetVal,'VariableNames',{'Patient','ROI','Channel','State','Significance','Coherence'});

lmeTable.ROI = reordercats(lmeTable.ROI,targetROI);


% Define LME model
selectedModel = fitlme(lmeTable, 'Coherence ~ 1 + ROI*State +  (1+State|Patient) + (1|Channel:Patient)', 'DummyVarCoding','reference','FitMethod','REML');

% Plotting Linear mixed-effects model
inv_logit = @(x) (exp(x))./(1+exp(x)); % inverse logit transform
num_ROIs = length(targetROI);
States = unique(state,'stable');
num_states = length(unique(States));
M = NaN(num_ROIs,num_states);
Ci = NaN(num_ROIs,2*num_states);
for s = 1:num_states
    for r = 1:num_ROIs
        tmptable = table(categorical({'NA'}),categorical(targetROI(r)),categorical(States(s)),categorical({'NA'}),'VariableNames',{'Patient','ROI','State','Channel'});
        [meanB,CI] = selectedModel.predict(tmptable);
        M(r,s) = meanB;
        Ci(r,2*s-1:2*s) = CI;
    end
end
Ci = inv_logit(Ci); M = inv_logit(M);
xaxs = 1:30:(30*length(targetROI));
% plot figure;
h1 = figure('Position',[200,400,1300,400]);
subplot ('Position',[0.06 0.3 0.92 0.63]); hold on;
colorStmp = [colorS1;colorS2];
for kk = 1:num_states
    currAxs = xaxs + 7*kk-10;
    errorbar(currAxs, M(:,kk),M(:,kk)-Ci(:,2*kk-1),Ci(:,2*kk)-M(:,kk),"s","MarkerSize",15,"MarkerEdgeColor","none","MarkerFaceColor","none",...
        'Color',colorStmp(kk,:),'LineWidth',1.5);
    scatter(currAxs,M(:,kk),80,Marker="o",MarkerEdgeColor="none",MarkerFaceColor= brighten(colorStmp(kk,:),-0.5),MarkerFaceAlpha=0.85);
end
%
s1 = gca;
s1.XAxis.TickValues = xaxs;
s1.XAxis.TickLabels = targetROI;
legend('',legendTxt{1},'',legendTxt{2},box='off',orientation='horizontal');
ylabel('Predicted Means (unitless)');
xlim([xaxs(1)-16 xaxs(end)+15]);
ylim([0 1.05]);
set(gcf,'color','w'); box off;
set(gca,'fontSize',16);
% Contrast Coding
coefNames = selectedModel.CoefficientNames;
% Here, we're looking to form contrasts for each ROI comparing states
p_uncorr = nan(1,num_ROIs);
%stateComp = [1,2,3];
for r = 1:num_ROIs
    % Reset H for each ROI
    H = zeros(num_states, length(coefNames));
    %fprintf('Results for ROI %s:  ', targetROI{r});
    for s = 1:num_states
        H(s, : ) = double(ismember(coefNames,{'(Intercept)',strcat('ROI_',targetROI{r}),strcat('ROI_',targetROI{r},':',sprintf('State_%s',char(States(s)))),sprintf('State_%s',char(States(s)))}));
    end
    a = nchoosek(1:num_states,2);
    H2 = H(a(:,1), : ) - H(a(:,2), : );
    % 3. Test the contrasts
    [p, F, DF1, DF2] = coefTest(selectedModel, H2, zeros(size(H2,1),1), 'DFMethod', 'satterthwaite');
    p_uncorr(r) = p;%*num_ROIs;
    %fprintf('Uncorrected p-values: %0.4f\n',p);
end
p_values = mafdr(p_uncorr,'BHFDR',true);

for r = 1:num_ROIs
    fprintf('%s Uncorrected p: %0.4f and FDR-corrected: %0.4f\n',targetROI{r},p_uncorr(r),p_values(r));
end
% Display p-values on the bar plot
starH = max(Ci(:,[2,4]),[],2);
for r = 1:num_ROIs
    yPos = starH(r) + 0.05; % Adjusting the vertical position to be slightly above the highest bar for that ROI
    xPos = xaxs(r);

    if p_values(r) < 0.001
        signifStr = '**';
    elseif p_values(r) < 0.05
        signifStr = '*';
    else
        signifStr = ''; % No asterisks for non-significant results
    end

    text(xPos, yPos, signifStr, 'HorizontalAlignment', 'center', 'FontSize', 15, 'FontWeight', 'bold', 'Color', [0.3 0.1 0.1]);
end
title('LME model for 2-states');

end