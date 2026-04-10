function plotPatientSagittal(patientID,coordM,indx,tmpVal,BrainAlpha,Msize,colorV,Malpha,BrainColor,hemThr)
% plotPatientSagittal(patientID,coordM,indx,tmpVal,BrainAlpha,Msize,colorV,Malpha,BrainColor,brainsurf,hemThr)

% ---------- Inputs & defaults ----------
if ~isstring(patientID), patientID = num2str(patientID); end
if nargin < 9  || isempty(BrainColor), BrainColor = [0.78 0.7 0.7]; end
if nargin < 10 || isempty(hemThr),     hemThr     = 0;      end
if isempty(Msize), Msize = [40,200]; end

% ---------- Legend bubble sizes ----------
roundM      = @(x,m) round(x*10^m)./10^m;
PlotValues  = tmpVal(indx);
values      = roundM(linspace(0.2,0.8,4),2);             % legend labels
markSize    = floor(values .* linspace(Msize(1),Msize(2),4));

% ---------- Surface files & patches ----------
MapPath = '.\MNI_map\';
lhSurf  = ls(fullfile(MapPath, ['*', patientID, '*lh*surf*']));
rhSurf  = ls(fullfile(MapPath, ['*', patientID, '*rh*surf*']));

patchL  = getpatch(fullfile(MapPath, lhSurf), BrainColor, BrainAlpha);
patchR  = getpatch(fullfile(MapPath, rhSurf), BrainColor, BrainAlpha);

% ---------- Sort by value & compute dot sizes ----------
Cord                 = coordM(indx,:);                       % subset coordinates
[sortValue,sIndx]    = sort(PlotValues,'ascend');
dotSizes             = floor(linspace(Msize(1),Msize(2),numel(PlotValues)) .* sortValue);
scord                = Cord(sIndx,:);
rightIndx            = scord(:,1) > hemThr;

%% ---------- RIGHT hemisphere: significant sites + legend ----------
figure('Position',[300,100,500,700], ...
    'Name', [num2str(patientID),' Right Hemisphere'], ...
    'NumberTitle', 'off');
hold on;
for ind = 1:numel(markSize)
    scatter3(77,-102, 50 + 8*ind, markSize(ind), ...
        'MarkerFaceColor', colorV, 'MarkerEdgeColor', [0.2 0.2 0.2]);
    text(77, -110, 50 + 8*ind, num2str(values(ind)), 'VerticalAlignment', 'middle');
end
set(groot,'defaultLegendAutoUpdate','off');
hR = gca; patch(hR, patchR);
setscatterplot(hR, scord(rightIndx,:), dotSizes(rightIndx), colorV, Malpha);
light(hR,'position', [200000 0 0]); view(hR, [90 0 0]);

% ---------- RIGHT coverage (all contacts) ----------
scSize = 35;
figure('Position',[750, 100, 590, 600], ...
    'Name', [num2str(patientID),' Right Coverage'], ...
    'NumberTitle', 'off');
covR = gca; hold(covR, 'on');
patch(covR, patchR);
covRightIndx = coordM(:,1) > hemThr;
scatter3(covR, coordM(covRightIndx,1), coordM(covRightIndx,2), coordM(covRightIndx,3), ...
    scSize .* ones(sum(covRightIndx), 1), ...
    'MarkerFaceColor', [0.4 0.4 0.4], 'MarkerFaceAlpha', 0.9, 'MarkerEdgeColor', [0.1 0.1 0.1]);
light(covR, 'position', [200000 0 0]); view(covR, [90 0 0]);
material(covR, 'dull'); axis(covR,'equal'); axis(covR,'tight'); lighting(covR, 'gouraud');
covR.ZAxis.Visible = 'off'; zlim(covR, [-65 95]); ylim(covR, [-120 80]);
hold(covR, 'off');

%% ---------- LEFT coverage ----------
figure('Position',[250, 100, 590, 600], ...
    'Name', [num2str(patientID),' Left Coverage'], ...
    'NumberTitle', 'off');
covL = gca; hold(covL, 'on');
patch(covL, patchL);
scatter3(covL, coordM(~covRightIndx,1), coordM(~covRightIndx,2), coordM(~covRightIndx,3), ...
    scSize .* ones(sum(~covRightIndx), 1), ...
    'MarkerFaceColor', [0.4 0.4 0.4], 'MarkerFaceAlpha', 0.9, 'MarkerEdgeColor', [0.1 0.1 0.1]);
light(covL, 'position', [-200000 0 0]); view(covL, [-90 0 0]);
material(covL, 'dull'); axis(covL,'equal'); axis(covL,'tight'); lighting(covL, 'gouraud');
covL.ZAxis.Visible = 'off'; zlim(covL, [-65 95]); ylim(covL, [-120 80]);
hold(covL, 'off');

% ---------- LEFT hemisphere: significant sites + legend ----------
figure('Position',[300,100,500,700], ...
    'Name', [num2str(patientID),' Left Hemisphere'], ...
    'NumberTitle', 'off');
hold on;
for ind = 1:numel(markSize)
    scatter3(77,-100, 50 + 8*ind, markSize(ind), ...
        'MarkerFaceColor', colorV, 'MarkerEdgeColor', [0.2 0.2 0.2]);
    text(77, -115, 50 + 8*ind, num2str(values(ind)), 'VerticalAlignment', 'middle');
end
set(groot,'defaultLegendAutoUpdate','off');
hL = gca; patch(hL, patchL);
setscatterplot(hL, scord(~rightIndx,:), dotSizes(~rightIndx), colorV, Malpha);
light(hL,'position', [-200000 0 0]); view(hL, [-90 0 0]);
%% templates
bcolor = [0.93 0.93 0.94]; alph = 0.93;
% generate template Right
figure('Position',[900, 100, 590, 600],'Name', [num2str(patientID),' Right Surf'], 'NumberTitle', 'off');
hrb = gca;
patch(hrb,getpatch(fullfile(MapPath,rhSurf),bcolor, alph));
axis(hrb,'equal');axis(hrb,'tight');
material(hrb, 'dull'); lighting(hrb, 'gouraud');
view(hrb, [90 0 0]); % lateral view Right
light(hrb, 'position', [900000 0 0]);
hrb.ZAxis.Visible = 'off'; zlim(hrb, [-65 95]); ylim(hrb, [-120 80]);
% generate template Left
figure('Position',[150, 100, 590, 600],'Name', [num2str(patientID),' Left Surf'], 'NumberTitle', 'off');
hlb = gca;
patch(hlb,getpatch(fullfile(MapPath,lhSurf),bcolor, alph));
axis(hlb,'equal'); axis(hlb,'tight');
material(hlb, 'dull'); lighting(hlb, 'gouraud')
view(hlb, [-90 0 0]); % lateral view Right
light(hlb, 'position', [-900000 0 0]);
hlb.ZAxis.Visible = 'off'; zlim(hlb, [-65 95]); ylim(hlb, [-120 80]);
end

% ================== HELPERS ==================

function hemPatch = getpatch(filename, PatchColor, Patchalpha)
figHandle    = openfig(filename, 'invisible');
patchHandles = findobj(figHandle, 'Type', 'patch');
patchObj     = patchHandles(1);
faces        = patchObj.Faces;
vertices     = patchObj.Vertices;
hemPatch     = create_patch(vertices, faces, PatchColor, Patchalpha);
end

function setscatterplot(figAx, Coord, dotSizes, colorV, alphaM)
hold(figAx, 'on');
h1 = scatter3(figAx, Coord(:,1), Coord(:,2), Coord(:,3), dotSizes, colorV, 'filled');
h1.MarkerFaceAlpha = alphaM;
h1.MarkerEdgeColor = [0.2 0.2 0.2];

if mean(Coord(:,1)) > 0
    light(figAx, 'position', [-200000 0 0]);
    set(gcf, 'Position', [900, 100, 630, 620]);
    view(figAx, [-90 0 0]);
else
    light(figAx, 'position', [200000 0 0]);
    set(gcf, 'Position', [350, 100, 630, 620]);
    view(figAx, [90 0 0]);
end

axis(figAx, 'equal'); axis(figAx, 'tight'); ylim(figAx, [-120 80]); xlim(figAx, [-80 80]); zlim(figAx, [-69 95]);
figAx.ZAxis.Visible = 'off';
material(figAx, 'dull');
hold(figAx, 'off');
end
