function [newIndx] = sortROI(UnqRois)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
newIndx = zeros(length(UnqRois),1);
RoiOrder = {'SFG','MFG','IFG','ACC','MCC','PCC','G rectus','Orbital G','TP','STS','STG','MTG','ITG','STP','Fusiform G','Insula'...
    ,'Amygdala','Hippocampus','Postcentral G','Precentral G','Paracentral L','SPL','SMG','AngG','Precuneus','Thalamus'};
r=1;
for k=1:length(RoiOrder)
    indx = find(ismember(UnqRois,RoiOrder(k)));
    if ~isempty(indx)
        newIndx(r) = indx;
        r = r+1;
    end
end
end
