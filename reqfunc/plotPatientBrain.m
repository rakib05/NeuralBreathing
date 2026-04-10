function plotPatientBrain(patientID,BrainType,alphaV,BrainColor,figAx,hemRev)
% plotPatientBrain(patientID,BrainType,alphaV,BrainColor,figAx,hemRev)
% BrainType--> type of the Brain map, 0--> default 1--> both hemisphere
% hemRev is true: plots radiological convention
%   Detailed explanation goes here
if ~isstring(patientID); patientID = num2str(patientID); end
if nargin < 2 || isempty(BrainType); BrainType = 0;     end
if nargin < 3 || isempty(alphaV); alphaV = 0.2;   end
if nargin < 4 || isempty(BrainColor); BrainColor = [0.78 0.7 0.7];end
if nargin < 5 || isempty(figAx)
    figh = figure('Position',[300,100,500,700]);
    ax = axes('parent',figh,'Position',[0.13 0.13 0.81 0.815]);
else
    ax = figAx;
end
% if hemRev = true, Left Hem will be on right side as MRI
if nargin < 6 || isempty(hemRev); hemRev = false;end

MapPath = '.\MNI_map\';
lhSurf = ls(fullfile(MapPath,['*',patientID,'*lh*surf*']));
rhSurf = ls(fullfile(MapPath,['*',patientID,'*rh*surf*']));
% Open the .fig file
patchL = getpatch(fullfile(MapPath,lhSurf),BrainColor, alphaV,hemRev); 
patchR = getpatch(fullfile(MapPath,rhSurf),BrainColor, alphaV,hemRev); 
patch(ax,patchL);
hold(ax,"on");
if BrainType == 1
    patch(ax,patchR);
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
ylim([-117 80])
xlim([-80 80])
material metal
end

function hemPatch = getpatch(filename,PatchColor, Patchalpha,radiologConv)
figHandle = openfig(filename, 'invisible');
patchHandles = findobj(figHandle, 'Type', 'patch');
patchObj = patchHandles(1);
% Extract the faces and vertices from the patch object
faces = patchObj.Faces;
vertices = patchObj.Vertices;
if radiologConv; vertices(:,1) = -vertices(:,1); end 
hemPatch = create_patch(vertices,faces,PatchColor, Patchalpha);
end
