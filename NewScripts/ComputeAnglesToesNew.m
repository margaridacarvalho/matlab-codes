%computes Angles for the toes
global ftimes fst_timeS last_timeS lst_contact1S fst_contact2S

load('GaitSubjectData.mat')
RightStride=1;
AngleContactR=DrivingJoints(4).Angles;
AngleContactL=DrivingJoints(8).Angles;

for i=1:3
    I=find(ForcePlates(i).Data(:,1));
    ini_step(i)=I(1);
    fin_step(i)=I(end);
end

%Plot do momento inicial de contacto
figure
plot(AngleContactL)
hold on
plot(60, AngleContactL(60), '*'); %FIRST CONTACT WITH PLATE 3
hold on
plot(72, AngleContactL(72), '*'); %LAST CONTTACT WITH PLATE 2
 
%plot angles and COPx
% figure
% subplot(2,1,1)
% plot(AngleContactR*500)
% hold on
% %subplot(2,2,3)
% plot(ForcePlates(2).Data(:,1))
% subplot(2,1,2)
% plot(AngleContactL*500)
% hold on%subplot(2,2,4)
% plot(ForcePlates(1).Data(:,1))
% hold on
% plot(ForcePlates(3).Data(:,1))

%Angle valors cycle starting on LAST contact of left foot with ground
CycleAngleContactR=AngleContactR(fin_step(1):fin_step(3));
CycleAngleContactL=AngleContactL(fin_step(1):fin_step(3));
CycleTime=fin_step(3)-fin_step(1);
%Angle valors cycle starting on FIRST contact of left foot with ground
CyclicAngleContactR=[CycleAngleContactR;CycleAngleContactR;CycleAngleContactR];
CyclicAngleContactL=[CycleAngleContactL;CycleAngleContactL;CycleAngleContactL];
CyclicAngleContactR(1:(ini_step(3)-fin_step(1)))=[];
CyclicAngleContactL(1:(ini_step(3)-fin_step(1)))=[];

figure
plot(CyclicAngleContactL)
hold on
plot(AngleContactL)

% figure
% plot(CyclicAngleContactR,'r')
% hold on
% plot(CyclicAngleContactL,'g')

%Create Splines for the Angles
%FIQUEI AQUI, CONFIRMAR TUDO
%timevectorR=zeros(1,length(CyclicAngleContactR));

%Define vector from INITIAL contact with plate 1(left foot) till FINAL 
%contact with plate 2(right foot)
nR= length(CyclicAngleContactR(1:(CycleTime-12))); %ta mal
timevectorR = linspace(fst_timeS ,last_timeS,nR); %CORFIRMAR 
%y = linspace(x1,x2,n) generates n points. The spacing between the points is (x2-x1)/(n-1).


% CyclictimevectorR=[timevectorR,timevectorR];
splineAngleR=spline(timevectorR,CyclicAngleContactR(1:(CycleTime-12)));
splineAngleL=spline(timevectorR,CyclicAngleContactL(1:(CycleTime-12)));


% nL= length(AngleContactL);
% timevectorL = linspace(fst_contact2S,last_timeS,nL);
% splineAngleLAux=spline(timevectorL,AngleContactL);
% 
% splineAngleR(i)=splineAngleRAux;
% splineAngleL(i)=splineAngleLAux;

%Talvez tentar correlãção com COPS

%AngValorsLAux=(ppval(splineAngleL(1),timevectorL)+ppval(splineAngleL(1),timevectorL))/2;

if RightStride==1
    for ind=1:length(ftimes)
        
        AngValorsR(ind)=ppval(splineAngleR,ftimes(ind));

        
        AngValorsL(ind)=ppval(splineAngleL,ftimes(ind));

    end
end

figure
plot(AngValorsL)
hold on
plot(AngleContactL)

save('AnglesRightToeNew.mat','AngValorsR')
save('AnglesLeftToeNew.mat','AngValorsL')
 