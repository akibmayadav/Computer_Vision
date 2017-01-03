%%%%%% CS 281B %%%%%%%
%%%%%% Advanced Computer Vision Assignment_1 %%%%%%%
%%%%%% Author : Ambika Yadav %%%%%

%%% MANN - HILDRET EDGE DETECTION %%%
%%% ZERO CROSSING FUNCTION %%%

function z = Zero_Crossing(img)
    [x, y] = size(img);
    z = zeros(x,y);
    sig = sign(img);
    [r,c] = find(sig(2:x-1,2:y-1)>0);
    for k=1:length(r)
        i = r(k)+1;
        j = c(k)+1;
        s = sig(i-1:i+1,j-1:j+1) * sig(i,j);
        if any(any(s == -1))
            z(i,j)=1;
        end
    end
end

