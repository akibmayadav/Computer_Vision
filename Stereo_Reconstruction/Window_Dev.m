function [ window ] = Window_Dev( imageMatrixBW, thisCol, thisRow, size, scale)
    width = scale * size;
    width = width - 1; 
    window = imageMatrixBW(:,thisCol:thisCol+width);   
    window = window(thisRow:thisRow+size-1,:);
end

 
