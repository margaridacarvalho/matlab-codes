%computes Angles for the toes
global ftimes fst_timeS last_timeS lst_contact1S fst_contact2S

load('GaitSubjectData.mat')
RightStride=1;

for i=1:3
    I=find(ForcePlates(i).Data(:,1));
    ini_step=I(1);
    fin_step=I(end);
%     AngleContactR=DrivingJoints(4).Angles(ini_step:fin_step);
%     AngleContactL=DrivingJoints(8).Angles(ini_step:fin_step);
%     
%     nR= length(AngleContactR);
%     timevectorR = linspace(fst_timeS,lst_contact1S,nR);
%     splineAngleRAux=spline(timevectorR,AngleContactR);
%     nL= length(AngleContactL);
%     timevectorL = linspace(fst_contact2S,last_timeS,nL);
%     splineAngleLAux=spline(timevectorL,AngleContactL);
%    
%    splineAngleR(i)=splineAngleRAux;
%    splineAngleL(i)=splineAngleLAux;
   
end

%AngValorsLAux=(ppval(splineAngleL(1),timevectorL)+ppval(splineAngleL(1),timevectorL))/2;

if RightStride==1
    for ind=1:length(ftimes)
        
        AngValorsR(ind)=ppval(splineAngleR(2),ftimes(ind));
        if ftimes(ind)< fst_timeS
            AngValorsR(ind)=AngleContactR(1);
        elseif ftimes(ind)> lst_contact1S
            AngValorsR(ind)=AngleContactR(end);
        end
        
        AngValorsL(ind)=ppval(splineAngleL(1),ftimes(ind));
%         AngValorsL(ind)=(ppval(splineAngleL(1),ftimes(ind))+ppval(splineAngleL(1),ftimes(ind)))/2;
        if ftimes(ind)< fst_contact2S
            AngValorsL(ind)=AngleContactL(1);
        elseif ftimes(ind)> last_timeS
            AngValorsL(ind)=AngleContactL(end);
        end
        
    end
end

save('AnglesRightToe.mat','AngValorsR')
save('AnglesLeftToe.mat','AngValorsL')
 