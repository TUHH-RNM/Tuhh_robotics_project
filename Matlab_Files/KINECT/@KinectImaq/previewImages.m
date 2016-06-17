function previewImages(self, id)
% previewImages  
%   kin.previewImages(id);

switch id
    case 1
        preview(self.vidRGB);
    case 2
        preview(self.vidDepth);
    case 3
        preview(self.vidIR);
    otherwise
        warning('Invalid id');
end
        

end