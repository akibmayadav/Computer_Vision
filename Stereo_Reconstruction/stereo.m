function [ dispMap ] = stereo( left_image, right_image, imageOut, disparityScale)
   
    % Assuming input images are grayscale
    M_L = imread(left_image);
    M_R = imread(right_image);
    scanWinSize = 7;
    
    % for all pixels in left window
    maxRows = 1 + size(M_L, 1) - scanWinSize;
    maxCols = 1 + size(M_L, 2) - scanWinSize;
    
    dispMap = zeros(maxRows,maxCols,1);
    
    for row = 1: maxRows
        for col = 1: maxCols 
           
            % left scan window
            left_window = Window_Dev(M_L, col, row, scanWinSize, 1);      
            
            % right support window parameters
            right_window_width = scanWinSize*disparityScale;            
            right_win_row = col - (scanWinSize * ((disparityScale-1)/2)) - ((scanWinSize-1)/2);  
            right_win_col = row ;
            
            if (right_win_row < 1)
                right_win_row = 1;
            end 
            
            if (right_win_row > 1 + size(M_L, 2) - right_window_width)
                right_win_row = 1 + size(M_L, 2) - right_window_width;
            end
            
            if (right_win_col < 1)
                right_win_col = 1;
            end
            
            if (right_win_col > 1 + size(M_L, 1) - right_window_width)
                right_win_col = 1 + size(M_L, 1) - right_window_width;
            end
            
            % get large support window B&W
            right_window = Window_Dev(M_R, right_win_row, right_win_col, scanWinSize, disparityScale);             
            
            % for each pixel in large window   
            X_m = 1;
            max_Disp = -9999999;
            array_Width = (disparityScale * scanWinSize) - (scanWinSize -1 );
            xMid = ((array_Width - 1) / 2) + 1;
            for yrCurr = 1 : 1 + (size(right_window, 1) -scanWinSize)
                for xrCurr = 1 : 1 + (size(right_window, 2) - scanWinSize)
           
                    matRsupp = Window_Dev(right_window, xrCurr, yrCurr, scanWinSize, 1);                    
                    tempDisp = Square_distance(left_window, matRsupp);                    
                    
                    if (tempDisp > max_Disp)
                        max_Disp = tempDisp;
                        X_m = xrCurr;   
                    end
                end
            end
            
            xVector = X_m - xMid + (2 * (xMid - X_m));
            mappedVal = (255 / (xMid -1)) * abs(xVector);            
            dispMap(row, col, 1) = uint8(mappedVal);
        end
    end  
    imwrite(dispMap(:,:,1),imageOut,'GIF');
    imshow(imageOut);
end

