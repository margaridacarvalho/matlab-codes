
storedStructure = load('LowerLimbHorsmannDataNoHallux.mat');
TotalBodies = storedStructure.TotalBodies ;
TotalJoints = storedStructure.TotalJoints;
TotalLeftMuscleData= storedStructure.TotalLeftMuscleData;
TotalLigaments=storedStructure.TotalLigaments;
TotalMuscleData=storedStructure.TotalMuscleData;

TotalBodies.Name(11) = [];TotalBodies.Name(6) = [];
TotalBodies.OriginalCoM(11,:) = [];TotalBodies.OriginalCoM(6,:) = [];
TotalBodies.Configuration(:,11) = [];TotalBodies.Configuration(:,6) = [];
TotalBodies.Mass(11) = [];TotalBodies.Mass(6) = [];
TotalBodies.CoM(11,:) = [];TotalBodies.CoM(6,:) = [];
TotalBodies.Inertias(11) = [];TotalBodies.Inertias(6) = [];
TotalBodies.JointCenter(11,:) = [];TotalBodies.JointCenter(6,:) = [];
TotalBodies.BodyPlot(11) = [];TotalBodies.BodyPlot(6) = [];

TotalJoints.Name(12) = [];TotalJoints.Name(6) = [];
TotalJoints.Center(12,:) = [];TotalJoints.Center(6,:) = [];
TotalJoints.Axis(12,:) = [];TotalJoints.Axis(6,:) = [];
TotalJoints.Bodies(12,:) = [];TotalJoints.Bodies(6,:) = [];
TotalJoints.LocalCenter(12,:) = [];TotalJoints.LocalCenter(6,:) = [];
TotalJoints.LocalAxis(12,:) = [];TotalJoints.LocalAxis(6,:) = [];

TotalLeftMuscleData()
save('LowerLimbHorsmannDataNoHallux.mat', 'TotalBodies', 'TotalJoints', 'TotalLeftMuscleData', 'TotalLigaments', 'TotalMuscleData' );