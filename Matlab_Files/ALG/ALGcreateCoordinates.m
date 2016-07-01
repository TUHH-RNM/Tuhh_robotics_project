function coord = ALGcreateCoordinates(points)
    diffVec21 = points(2,:) - points(1,:);
    Cx = diffVec21/ALGlenghtVec(diffVec21);
    
    diffVec31 = points(3,:) - points(1,:);
    proj = dot(Cx,diffVec31)*Cx;
    diffVec31 = diffVec31 - proj;
    Cy        = diffVec31/ALGlenghtVec(diffVec31);
    
    crossProd = cross(Cx,Cy);
    Cz = crossProd / ALGlenghtVec(crossProd);
    
    coord = [Cx;Cy;Cz];

end