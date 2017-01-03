%%%%%% CS 281B %%%%%%%
%%%%%% Advanced Computer Vision Assignment_1 %%%%%%%
%%%%%% Author : Ambika Yadav %%%%%

%%% MANN - HILDRET EDGE DETECTION %%%
%%% FILTER FUNCTION %%%

function X = Assignment_Filter(sigma,I)
size = (6*sigma);
G = fspecial('gaussian',[size,size],sigma);
L = [0 -1 0; -1 4 -1; 0 -1 0];
LoG = conv2(G,L);
X_1 = conv2(I,LoG);
X = Zero_Crossing(X_1);
end 

