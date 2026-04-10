function roiscatterplot(Values,locations,colorP,yLim)
% scatterplotROIs creates a scatter plot of Values by specified ROIs.
% Values: Numeric array of values to plot.
% locations: Cell array of ROI names corresponding to each value in Values.
% colorP: RGB color for scatter plot markers (unfilled with linewidth 1).
% yLim: Y-axis limits for the plot.

if nargin < 4 || isempty(yLim); yLim = [0 1]; end
if nargin < 3 || isempty(colorP); colorP = [0.6 0.22 0.77]; end

% Each ROI bar plot
LocOR = roiNameUpdate(locations);

% Unique ROIs
unqROI = unique(LocOR);
unqROI(ismember(unqROI, 'Thalamus')) = [];
Nroi = length(unqROI);
CountsROI = zeros(Nroi, 1);
plotData = cell(Nroi, 1);

% Prepare data for plotting
for kk = 1:Nroi
    indxROI = strcmp(LocOR, unqROI{kk});
    CountsROI(kk) = sum(indxROI);
    plotData{kk} = Values(indxROI)';
end

% Remove ROIs with less than 5 total contacts
rmvIndx = CountsROI <= 5;
CountsROI(rmvIndx) = [];
unqROI(rmvIndx) = [];
plotData(rmvIndx) = [];

roiInx = sortROI(unqROI);
unqROI = unqROI(roiInx);
plotData = plotData(roiInx);
CountsROI = CountsROI(roiInx);

% Mean values
meanCorr = cell2mat(cellfun(@mean, plotData, 'UniformOutput', false));
maxVal = cell2mat(cellfun(@max, plotData, 'UniformOutput', false));
% Define x-axis positions for each unique ROI
xaxs = 1:length(unqROI);

% Create scatter plot
figure('Position',[150 350 1350 320]);
hold on;
for i = 1:length(unqROI)
    % Scatter plot of all data points for each ROI
    scatter(repmat(xaxs(i), length(plotData{i}), 1), plotData{i}, 30, ...
        'MarkerEdgeColor', colorP, 'MarkerFaceColor', colorP, 'MarkerFaceAlpha', 0.1, 'LineWidth', 1.5);
end

% Overlay mean values as larger filled markers
%scatter(xaxs, meanCorr, 120, 'o', 'MarkerEdgeColor', 'none', 'MarkerFaceColor', 'k', 'MarkerFaceAlpha', 0.8);
scatter(xaxs,meanCorr,120, Marker = "_",MarkerEdgeColor = [0.2,0.2 0.2],MarkerEdgeAlpha=0.8, LineWidth=2.5);
%plot(xaxs, meanCorr, '-k', 'LineWidth', 2);
% Set x-axis ticks and labels
xticks(xaxs);
xticklabels(unqROI);

% Customize axes labels, title, and limits
ylabel('Coherence');
yticks([0,0.25,0.5,0.75,1]);
set(gcf,'color','w'); box off;
set(gca,'fontSize',15);
ylim(yLim);
hold off;
text(xaxs+0.05, maxVal+ 0.04,num2str(CountsROI),...
     'vert','bottom','horiz','center','FontSize',18);

end



