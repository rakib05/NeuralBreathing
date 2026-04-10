function Roiname = roiNameUpdate(Roiname)
% to update ROI name i.e., removing or correcting dual entries
indLoc = contains(Roiname,'Anterior cingulate');
Roiname(indLoc) = {'ACC'};

indLoc = contains(Roiname,'Fusifo');
Roiname(indLoc) = {'Fusiform G'};

indLoc = contains(Roiname,{'IFG p','Inferior frontal'});
Roiname(indLoc) = {'IFG'};

indLoc = contains(Roiname,'Orbital');
Roiname(indLoc) = {'Orbital G'};

indLoc = contains(Roiname,'Precentral');
Roiname(indLoc) = {'Precentral G'}; 

indLoc = contains(Roiname,'Postcentral');
Roiname(indLoc) = {'Postcentral G'}; 

indLoc = contains(Roiname,'Paracentral');
Roiname(indLoc) = {'Paracentral L'}; 

indLoc = contains(Roiname,{'Posterior dorsal cingulate','Posterior ventral cingulate','Post. Cing'});
Roiname(indLoc) = {'PCC'};
% indLoc = contains(Roiname,'Posterior ventral cingulate');
% Roiname(indLoc) = {'Post. ventral Cing'};

indLoc = contains(Roiname,{'Middle-anterior cingulate','Middle anterior cingulate'});
Roiname(indLoc) = {'MCC'};

indLoc = contains(Roiname,{'Posterior middle cingulate','Middle posterior cingulate','Middle-posterior cingulate'});
Roiname(indLoc) = {'MCC'};

indLoc = contains(Roiname,'Inferior temporal');
Roiname(indLoc) = {'ITG'};
indLoc = contains(Roiname,'Superior temporal g');
Roiname(indLoc) = {'STG'};
indLoc = contains(Roiname,'Middle temporal');
Roiname(indLoc) = {'MTG'};
indLoc = contains(Roiname,'Superior temporal s');
Roiname(indLoc) = {'STS'};


indLoc = contains(Roiname,'rectus');
Roiname(indLoc) = {'G rectus'};

indLoc = contains(Roiname,'Middle frontal');
Roiname(indLoc) = {'MFG'};
indLoc = contains(Roiname,'Superior frontal');
Roiname(indLoc) = {'SFG'};

indLoc = contains(Roiname,{'PHG','Parahipp'});
Roiname(indLoc) = {'PHG'};

indLoc = contains(Roiname,'Superior parietal lobule');
Roiname(indLoc) = {'SPL'};

indLoc = contains(Roiname,{'Supramarginal','SMG'});
Roiname(indLoc) = {'SMG'};
indLoc = contains(Roiname,'Angular g');
Roiname(indLoc) = {'AngG'};
indLoc = contains(Roiname,{'Intraparietal sulcus'});
Roiname(indLoc) = {'IPL'};

indLoc = contains(Roiname,{'TFG','Transverse frontopolar'});
Roiname(indLoc) = {'TFG'};

indLoc = contains(Roiname,{'Heschl','HG','PP','PT','Planum'});
Roiname(indLoc) = {'STP'};

end