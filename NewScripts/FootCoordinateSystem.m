function A = FootCoordinateSystem(STJ, CALC, FirstMTH, FifthMTH, RightFoot)
% This function defines the orientation of the foot coordinate system. 
% The definition of the coordinate system is better explained in the paper
% "Adjustments to McConville et al. and Young et al. body segment inertial
% parameters"
% STJ - Subtalar joint center
% CALC - Calcaneus
% FirstMTH - head of the 1st metatarsus
% FifthMTH - head of the 5th metatarsus

% Definition of the MTP vector (line that goes from the 1st metatarsus to
% the 5th metatarsus)
MTP = (FifthMTH - FirstMTH);

% Definition of the midpoint between the 1st and 5th metatarsus
MidPoint = (FirstMTH + FifthMTH) / 2;

% Y axis
AuxVector1 = (FirstMTH - CALC) / norm(FirstMTH - CALC);
AuxVector2 = (FifthMTH - CALC) / norm(FifthMTH - CALC);

% Vector normal to the plane
Y = cross(AuxVector1, AuxVector2);
if (RightFoot == 1)
    Y = - Y' / norm(Y);
else
    Y = Y' / norm(Y);
end

% X axis
AuxVector3 = (MidPoint - CALC) / norm(MidPoint - CALC);
AuxVector4 = cross(AuxVector3, Y);

X = cross(Y, AuxVector4);
if (RightFoot == 1)
    X = X' / norm(X);
else
    X = - X' / norm(X);
end

% Z axis
Z = cross(X, Y);
Z = Z / norm(Z);

% Reference frame
A = [X, Y, Z];

% Checks the data
% plot3([ CALC(1) FirstMTH(1) FifthMTH(1)], [ CALC(2) FirstMTH(2) FifthMTH(2)],...
%      [ CALC(3) FirstMTH(3) FifthMTH(3)], 'p');
% % plot3([STJ(1) CALC(1) FirstMTH(1) FifthMTH(1)], [STJ(2) CALC(2) FirstMTH(2) FifthMTH(2)],...
% %     [STJ(3) CALC(3) FirstMTH(3) FifthMTH(3)], 'p');
% hold on;
% % text(STJ(1), STJ(2), STJ(3), 'STJ');
% text(CALC(1), CALC(2), CALC(3), 'CALC');
% text(FirstMTH(1), FirstMTH(2), FirstMTH(3), '1st');
% text(FifthMTH(1), FifthMTH(2), FifthMTH(3), '5th');
% 
% XAxis = CALC' + 0.25 * A(:,1);
% YAxis = CALC' + 0.25 * A(:,2);
% ZAxis = CALC' + 0.25 * A(:,3);
% 
% plot3([CALC(1) XAxis(1)], [CALC(2) XAxis(2)], [CALC(3) XAxis(3)], 'r');
% plot3([CALC(1) YAxis(1)], [CALC(2) YAxis(2)], [CALC(3) YAxis(3)], 'k');
% plot3([CALC(1) ZAxis(1)], [CALC(2) ZAxis(2)], [CALC(3) ZAxis(3)], 'b');
% axis square
% pause
% End of function
end