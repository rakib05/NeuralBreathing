function Patchdata = create_patch(vertices, faces, colorcord,alpha)
%PATCH_CONFIG
Patchdata.Vertices=vertices;
Patchdata.Faces=faces;
Patchdata.EdgeColor = 'none';
Patchdata.FaceAlpha=alpha;

if length(colorcord)==3
    Patchdata.FaceColor = colorcord;
else
    Patchdata.FaceColor = 'interp';
    Patchdata.FaceVertexCData =  colorcord;
end

end

                        