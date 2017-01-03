function H_final = ransac(matchedPoints1,matchedPoints2,iterations)
%% STEP 1 
 %Generating a set of random numbers to access random distinct matched
 %points.
 H_final= zeros(3,3);
 len1 = length(matchedPoints1);
 inliner_num = 0;
 old_inliner_num = 0;
 for i = 1:iterations
     randindex = randsample(len1, 4);
     matchedPointsloca = zeros(4,3);
     matchedPointslocb = zeros(4,3);
            for j = 1:4
                matchedPointsloca(j,:) = [matchedPoints1.Location(randindex(j),:) 1];
                matchedPointslocb(j,:)= [matchedPoints2.Location(randindex(j),:) 1];       
            end

 
 %% STEP 2 CALCULATE HOMOGRAPHY
 H = homography(matchedPointsloca,matchedPointslocb);
 
 %% STEP 3 FIND INLINERS AND ASSIGN THE FINAl MATRIX
 x_a = ones(len1,3) ;
 x_b = ones(len1,3) ;
 x_a(:,1:2)=matchedPoints1.Location(:,1:2);
 x_b(:,1:2)=matchedPoints2.Location(:,1:2);
 x_1 =( H * x_a')';
 for d = 1:len1
    distance = sqrt((x_1(d,1)-x_b(d,1))^2 + (x_1(d,2)-x_b(d,2))^2 + (x_1(d,3)-x_b(d,3))^2);
    if (distance < 6 )
        inliner_num = inliner_num +1;
    end 
 end
    if (inliner_num > old_inliner_num)
        old_inliner_num = inliner_num;
        H_final= H;
    end  
 
 end

end