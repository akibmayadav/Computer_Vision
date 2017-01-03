function [ SSD ] = Square_distance( L, R )
    intL = int16(L);
    intR = int16(R);
    SSDmatrix = (intL-intR);
    SSD = sumsqr(SSDmatrix);
    SSD = 0 - SSD;
end

