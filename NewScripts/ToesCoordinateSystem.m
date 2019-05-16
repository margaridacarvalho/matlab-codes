function A = ToesCoordinateSystem(FirstMTH, FifthMTH, BigToe, RightFoot)
% This function defines the orientation of the foot coordinate system. 
% FirstMTH - head of the 1st metatarsus
% FifthMTH - head of the 5th metatarsus
% Big toe

% Definition of the MTP vector (line that goes from the 1st metatarsus to
% the 5th metatarsus)
MTP = (FifthMTH - FirstMTH) / norm(FifthMTH - FirstMTH);

% Y axis
AuxVector1 = (BigToe - FirstMTH) / norm(BigToe - FirstMTH);

% Vector normal to the plane
Y = cross(AuxVector1, MTP);
if (RightFoot == 1)
    Y = - Y' / norm(Y);
else
    Y = Y' / norm(Y);
end

% X axis
X = cross(Y, MTP);
X = X' / norm(X);

% Z axis
Z = cross(X, Y);
Z = Z / norm(Z);

% Reference frame
A = [X, Y, Z];

% Checks the data
% plot3([FirstMTH(1) FifthMTH(1) BigToe(1)], [FirstMTH(2) FifthMTH(2) BigToe(2)],...
%     [FirstMTH(3) FifthMTH(3) BigToe(3)], 'p');
% hold on;
% text(FirstMTH(1), FirstMTH(2), FirstMTH(3), '1st');
% text(FifthMTH(1), FifthMTH(2), FifthMTH(3), '5th');
% text(BigToe(1), BigToe(2), BigToe(3), 'BT');
% 
% XAxis = FirstMTH' + 0.25 * A(:,1);
% YAxis = FirstMTH' + 0.25 * A(:,2);
% ZAxis = FirstMTH' + 0.25 * A(:,3);
% 
% plot3([FirstMTH(1) XAxis(1)], [FirstMTH(2) XAxis(2)], [FirstMTH(3) XAxis(3)], 'r');
% plot3([FirstMTH(1) YAxis(1)], [FirstMTH(2) YAxis(2)], [FirstMTH(3) YAxis(3)], 'k');
% plot3([FirstMTH(1) ZAxis(1)], [FirstMTH(2) ZAxis(2)], [FirstMTH(3) ZAxis(3)], 'b');
% axis square
% % pause
% End of function
end