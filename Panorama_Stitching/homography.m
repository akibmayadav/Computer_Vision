function H = homography(points1,points2)

A = zeros(size(8,9));
A(1:4,1:2)=-1*points1(1:4,1:2);
A(1:4,3)=-1;
A(1:4,4:6)=0;
A(5:8,1:3)=0;
A(5:8,4:5)=-1*points1(1:4,1:2);
A(5:8,6)=-1;
x=points1(:,1);
y=points1(:,2);
u=points2(:,1);
v=points2(:,2);
A(1:4,7)=u.*x;
A(1:4,8)=u.*y;
A(1:4,9)=u;
A(5:8,7)=v.*x;
A(5:8,8)=v.*y;
A(5:8,9)=v;

[evec,~] = eig(A'*A);
H_1 = reshape(evec(:,1),[3,3])';
H = H_1/H_1(end);


end