function plotbrainscatter(data,indx,tmpVal,BrHem,BrainAlpha,Msize,colorV,Malpha,BrainColor,lateralView)

if nargin < 9 || isempty(BrainColor); BrainColor = [0.78 0.7 0.7]; end
if nargin < 10 || isempty(lateralView); lateralView = false; end
if isempty(Msize); Msize = [40,200]; end
tmpVal = tmpVal(:);

roundM = @(x,m) round(x*10^m)./10^m;
PlotValues = tmpVal(indx);
% minVal = min(PlotValues); maxVal = max(PlotValues);
values = roundM(linspace(0.2,0.8,4),2); %roundM(linspace(maxVal,minVal,5),2);
markSize = floor(values.*linspace(Msize(1),Msize(2),4));
legentry=cell(size(markSize));
figure('Position',[300,100,500,700]); hold on;
for ind = 1:numel(markSize)
    if lateralView % for lateral view %%  view([-90 0 0])
        bubleg(ind) = scatter3(77,-102, 50 + 8*ind, markSize(ind),'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.2 0.2 0.2]);
        text(77, -110, 50 + 8*ind, num2str(values(ind)), 'VerticalAlignment', 'middle'); % Add text label
    else
        bubleg(ind) = scatter3(77,40 + 8*ind,46 + 8*ind, markSize(ind),'MarkerFaceColor',[0.3 0.3 0.3],'MarkerEdgeColor',[0.2 0.2 0.2]);
        text(87, 40 + 8*ind, 46 + 8*ind, num2str(values(ind)), 'VerticalAlignment', 'middle'); % Add text label
    end
end
set(groot,'defaultLegendAutoUpdate','off');
h1 = gca;

plotBrainPatch(BrHem,BrainAlpha,BrainColor,h1,false); % plot the template brain LH on right, RH on left
% plot Significant contacts in Awake breathing
Cord = data.ChnCoordinates(indx,:); % locIndx_aw from later section to plot only GM contacts
[sortValue,sIndx] = sort(PlotValues,'ascend');
dotS = linspace(Msize(1),Msize(2),length(PlotValues));
dotSizes  = floor(dotS(:).*sortValue);
h1 = scatter3(Cord(sIndx,1),Cord(sIndx,2),Cord(sIndx,3), dotSizes,colorV,'fill');
h1.MarkerFaceAlpha = Malpha;
h1.MarkerEdgeColor = [0.2 0.2 0.2];
%axis('off')
delete(findall(gcf,'Type','light'));
if lateralView
    view([-90 0 0]); zlim([-60 99]);
    h = gca; h.ZAxis.Visible = 'off';
    light('position', [-200000 0 0])
    set(gcf, 'Position',  [300, 100, 590, 600]);
else
    light('position', [0 0 300000])
end
camlight('headlight');
ylim([-110 80])
xlim([-80 80])
material metal
end