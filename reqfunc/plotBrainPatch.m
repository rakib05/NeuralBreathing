function plotBrainPatch(BrainType,alphaV,BrainColor,figAx,hemRev)
%plotbrainMap(patientNum,chansToPlot,valuesToPlot,BrainType)
% BrainType--> type of the Brain map, 0--> default 1--> patient specific
%   Detailed explanation goes here
if nargin < 1 || isempty(BrainType); BrainType = 0;     end
if nargin < 2 || isempty(alphaV); alphaV = [0.3,0.5];   end
if nargin < 3 || isempty(BrainColor); BrainColor = [0.78 0.7 0.7];end
if nargin <4 || isempty(figAx)
    figh = figure('Position',[300,100,500,700]);
    ax = axes('parent',figh,'Position',[0.13 0.13 0.81 0.815]);
else
    ax = figAx;
end
% if hemRev = true, Left Hem will be on right side as MRI
if nargin < 5 || isempty(hemRev); hemRev = false;end

MapPath = '.\MNI_map\';
tmpX = load([MapPath,'mni_tempRH']);
if hemRev
    tmpX.vertices(:,1) = -tmpX.vertices(:,1);
end
patchRh = create_patch(tmpX.vertices,tmpX.face,BrainColor, alphaV(1));
patch(ax,patchRh);
hold(ax,"on");
if BrainType == 1
    tmpX = load([MapPath,'mni_tempLH']);
    if hemRev
        tmpX.vertices(:,1) = -tmpX.vertices(:,1);
    end
    patchLh = create_patch(tmpX.vertices,tmpX.face,BrainColor, alphaV(1));
    patch(ax,patchLh);
end
set(gcf,'color','w');
if BrainType == 1
    light('position', [2000 0 0])
    light('position', [-2000 0 0])
    %     light('position', [0 0 3000])
    %     light('position', [0 0 -3000])
    lighting gouraud;
end
axis('equal'); axis('tight');
ylim([-110 80])
xlim([-80 80])
end
