
% Dictionary that will be updated for the markers
UpdatedDictionary.Model = 'LowerLimbModel';
UpdatedDictionary.MarkersName = {};
UpdatedDictionary.MarkersModel = {};

% Root = BiomechanicalModelDirectory();
CurrentP = path;

Subject = input('What is the name of the subject (folder) to be analyzed?\n','s');

% Restores original path
path(CurrentP);

% Adds the folder from the subject to the path
% addpath([Root,'LabData\',Subject]);

% Reads the data for the static position
[KineData, UpdatedDictionary] = ReadTSVMarkers(['C:\Users\Margarida\Desktop\MusculoskeletalModel\NewScripts\LabData\',Subject,'\S05_PD_01.tsv'],...
    UpdatedDictionary);


NFrames=length(KineData.Coordinates(:,1));
for i = 1 : NFrames
    
    % Reference frames of bodies i and j
    %             ABodyi = quat2dcm(GlobalPositionsCorrected(k, DrivingJoints(i).BodyiEntries(1) + 3 : DrivingJoints(i).BodyiEntries(1) + 6))';
    %             ABodyj = quat2dcm(GlobalPositionsCorrected(k, DrivingJoints(i).BodyjEntries(1) + 3 : DrivingJoints(i).BodyjEntries(1) + 6))';
    %
    % U and V vector
    RMMA = [KineData.Coordinates(i,28*3-2),KineData.Coordinates(i,28*3-1),KineData.Coordinates(i,28*3)];
    RMET01 = [KineData.Coordinates(i,31*3-2),KineData.Coordinates(i,31*3-1),KineData.Coordinates(i,31*3-1)];
    RMET05 = [KineData.Coordinates(i,32*3-2),KineData.Coordinates(i,31*3-1),KineData.Coordinates(i,32*3-1)];
    HALLUX= [KineData.Coordinates(i,34*3-2),KineData.Coordinates(i,34*3-1),KineData.Coordinates(i,34*3)];
    RHEEL=[KineData.Coordinates(i,30*3-2),KineData.Coordinates(i,30*3-1),KineData.Coordinates(i,30*3)];
    MidPoint = (RMET01 + RMET05) / 2;
    
    u = (MidPoint-RHEEL)'; %RMMA TO RMET01
    v = (HALLUX-RMET01)'; %RMET01 TO HALLUX
    
    
    SaveV(i,:)=v;
    %
    %     % Computation of the angle
    Angles(i) = acos(u' * v);
    %
    % End of the loop that goes through all frames
end

DataSpline = spline((1:NFrames), Angles);

% Computation of the derivatives of the spline
dDataSpline = fnder(DataSpline, 1);
d2DataSpline = fnder(dDataSpline, 1);

% q=;
% qd=;
RMMAi = [KineData.Coordinates(1,28*3-2),KineData.Coordinates(1,28*3-1),KineData.Coordinates(1,28*3)];
RMET01i = [KineData.Coordinates(1,31*3-2),KineData.Coordinates(1,31*3-1),KineData.Coordinates(1,31*3-1)];
RMET05i = [KineData.Coordinates(1,32*3-2),KineData.Coordinates(1,31*3-1),KineData.Coordinates(1,32*3-1)];
RHEELi=[KineData.Coordinates(1,30*3-2),KineData.Coordinates(1,30*3-1),KineData.Coordinates(1,30*3)];
HALLUXi= [KineData.Coordinates(1,34*3-2),KineData.Coordinates(1,34*3-1),KineData.Coordinates(1,34*3)];
AFooti = FootCoordinateSystem([], RHEEL, RMET01, RMET05, 1); %Right foot=1
AHalluxi = ToesCoordinateSystem(RMET01, RMET05, HALLUX, 1);

%initialize vector q
q(1:3)=RMET01i;
q(8:10)=[KineData.Coordinates(1,31*3-2),KineData.Coordinates(1,31*3-1)+10,KineData.Coordinates(1,31*3-1)];
q(1 + 3 : 1 + 6)=dcm2quat(AFooti');
q(8 + 3 : 8 + 6)=dcm2quat(AHalluxi');
qd(1 + 3 : 1 + 5)=ones(1,3)*0.1;
qd(7 + 3 : 7 + 5)=ones(1,3)*0.1;

Error=1;
Iteration=1;

for k = 1 : NFrames
    
    while (Error > 1e-4)
        
        RMMA = [KineData.Coordinates(k,28*3-2),KineData.Coordinates(k,28*3-1),KineData.Coordinates(k,28*3)];
        RMET01 = [KineData.Coordinates(k,31*3-2),KineData.Coordinates(k,31*3-1),KineData.Coordinates(k,31*3-1)];
        RMET05 = [KineData.Coordinates(k,32*3-2),KineData.Coordinates(k,31*3-1),KineData.Coordinates(k,32*3-1)];
        RHEEL=[KineData.Coordinates(k,30*3-2),KineData.Coordinates(k,30*3-1),KineData.Coordinates(k,30*3)];
        %         HALLUX= [KineData.Coordinates(k,34*3-2),KineData.Coordinates(k,34*3-1),KineData.Coordinates(k,34*3)];
        HALLUX=q(8:10);
        
        AFoot = FootCoordinateSystem([], RHEEL, RMET01, RMET05, 1); %Right foot=1
        AHallux = ToesCoordinateSystem(RMET01, RMET05, HALLUX, 1);
        
%         q(1 + 3 : 1 + 6)=dcm2quat(AFoot');
%         q(7 + 3 : 7 + 6)=dcm2quat(AHallux');
        
        %         ABodyi = quat2dcm(dcm2quat(AFoot'))';
        %         ABodyj = quat2dcm(q(BodyjEntries(1) + 3 : BodyjEntries(1) + 6))';
       
      
        ABodyi = AFoot;
        ABodyj = AHallux;
        
        % Definition of the u vector in the local frame
        uLocal = [1 0 0];%Axes(1,:)'; %FOOT (heel to midpoint 01 and 05)
        
        % Definition of the v vector in the local frame
        vLocal = [1 0 0];%Axes(2,:)'; %HALLUX (big toe to 01)
        
        %Constrait
        DriverConstraints = (ABodyi * uLocal')' * (ABodyj * vLocal') - cos(Angles(k));
        DriverFootConstraint=(q(1:3)-RMET01)';
        DriverFootConstraintAng=(q(4:7)-dcm2quat(AFoot'))';
        
        BodyiLocalP1=[0 0 0]; %RMET01
        BodyjLocalP1= [-0.1 0 0];%(RMET01i-HALLUXi);%RMET01
        BodyiLocalP2=[0 0 0.1];%(RMET01i-RMET05i) ;%RMET05
        BodyjLocalP2=[-0.1 0 0.1];%((RMET01i-RMET05i)+(RMET01i-HALLUXi));%RMET05
        
        [Gi,Li] = define_matriz_GL(dcm2quat(AFoot'));
        [Gj,Lj] = define_matriz_GL(dcm2quat(AHallux'));
        
        A_i = Gi * Li';
        A_j = Gj * Lj';
        %FALTA FUNTA HINGE
        %TALVEZ AQUI TENHA QUE ENTRAR O Q DO CORPO 1
        AnatomicalConstraints = junta_hinge (q', [],...
            1,  A_i,...  %BodyiEntries, A_i,...
            BodyiLocalP1',...
            BodyiLocalP2',...
            8, A_j,...  %BodyjEntries, A_j,...
            BodyjLocalP1',...
            BodyjLocalP2', 1, 1);
        
        TotalConstraints= [AnatomicalConstraints; DriverConstraints; DriverFootConstraint;DriverFootConstraintAng];
        %    AnatomicalConstraints = constr_jacob_gama(KinOpt, i, q',...
        %             qd', 1, 1);
        %         KinResult = constr_jacob_gama(InvDynOpt, positionFrame, vector_q,...
        %     vector_v, tipo_analise, parametros)
        %          AnatomicalConstraint = junta_hinge (vector_q, vector_v,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyiEntries, A_i,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyiLocalP1,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyiLocalP2,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyjEntries, A_j,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyjLocalP1,...
        %             InvDynOpt.ModelTopology.Joints(i).BodyjLocalP2, tipo_analise, parametros);
        % Entries for body i
        %         TotalJacobian(3 : 5) = - 1 * (((skewmatrix(ABodyi * uLocal) * ABodyi)' * (ABodyj * vLocal)))';
        
        % Entries for body j
        %         TotalJacobian(3 : 5) = - 1 * (((skewmatrix(ABodyj * vLocal) * ABodyj)' * (ABodyi * uLocal)))';
        
 %         q(1 + 3 : 1 + 6)=dcm2quat(AFoot');
%         q(7 + 3 : 7 + 6)=dcm2quat(AHallux');


        
        DriverJacobian(1 + 3 : 1 + 6) = - 2 * ...
            (((skewmatrix(ABodyi * uLocal') * ABodyi)' * (ABodyj * vLocal')))' *...
            Li;
        
        % Entries for body j
        DriverJacobian(8 + 3 : 8 + 6) = - 2 * ...
            (((skewmatrix(ABodyj * vLocal') * ABodyj)' * (ABodyi * uLocal')))' *...
            Lj;
        
        DriverFootJacobian(:,:)=zeros(3,14);
        DriverFootJacobian(1,1)=1; %talvez esteja mal colunas e linhas
        DriverFootJacobian(2,2)=1;
        DriverFootJacobian(3,3)=1;
        
        %         DriverFootJaconbianAng(:,1 + 3 : 1 + 6,:)=eye(4);
        DriverFootJacobianAng(:,:)=zeros(4,14);
        DriverFootJacobianAng(1,4)=1; %talvez esteja mal colunas e linhas
        DriverFootJacobianAng(2,5)=1;
        DriverFootJacobianAng(3,6)=1;
        DriverFootJacobianAng(4,7)=1;

        AnatomicalJacobian = junta_hinge (q', [],...
            1, A_i,...  %BodyiEntries, A_i,...
            BodyiLocalP1',...
            BodyiLocalP2',...
            8, A_j,...  %BodyjEntries, A_j,...
            BodyjLocalP1',...
            BodyjLocalP2', 2, 1);
        
        TotalJacobian= [AnatomicalJacobian; DriverJacobian; DriverFootJacobian;DriverFootJacobianAng];
       
        Deltaq = - TotalJacobian \ TotalConstraints;
        q = q + Deltaq';
        Error = norm(Deltaq);
        Iteration = Iteration + 1;
    end
    
    ConsistentPositions(i,:) = q;
    
    % NIU of the kinematic drivers
    LocalWi = qd(1 + 3 : 1 + 5);
    LocalWj = qd(7 + 3 : 7 + 5);
    
    % Global angular velocities of bodies i and j
    GlobalWi = ABodyi * LocalWi';
    GlobalWj = ABodyj * LocalWj';
    
    % Computation of u dot
    uDot = skewmatrix(GlobalWi) * (ABodyi * uLocal');
    vDot = skewmatrix(GlobalWj) * (ABodyj * vLocal');
    
    % Niu of the anatomical constraints
    AnatomicalNiu = junta_hinge (q', [],...
            1, A_i,...  %BodyiEntries, A_i,...
            BodyiLocalP1',...
            BodyiLocalP2',...
            8, A_j,...  %BodyjEntries, A_j,...
            BodyjLocalP1',...
            BodyjLocalP2', 4, 1);
    
    dAngle=ppval(dDataSpline,k);
    DriverNiu = -sin(Angles(k)) * dAngle;
    
    % Combination of the Niu
    DriverFootNiu= zeros(3,1);
    DriverFootNiuAng=zeros(4,1);
    
    TotalNiu = [AnatomicalNiu; DriverNiu; DriverFootNiu; DriverFootNiuAng];
    
    % Computation of the consistent velocities
    ConsistentVelocities(i,:) = TotalJacobian \ TotalNiu;
    % Updates the vector qd for the computation of gamma
    qd = ConsistentVelocities(i,:);
   
    
end