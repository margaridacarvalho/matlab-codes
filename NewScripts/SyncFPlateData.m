function [fst_timeS,last_timeS,splineFP1,splineFP2,lst_contact1S,fst_contact2S]=SyncFPlateData(FPData)

global Freq %treat data

%%Reads FORCEPLATE data frow RAW FILE

%Open plate RAW data
oldfileFP=fopen('K5R_110323_1_022_forceplate_raw.csv');

% Stopping criteria
StopCycle = 0;

%Frequency for raw forceplates data 
FreqR=960;

%%READS FILE
% Reads the data until finding the line starting with "Frame''
while (StopCycle == 0)   
    % Reads the next line
    Line = fgetl(oldfileFP); 
    if (length(Line) > 8 && strcmpi(Line(1:5),'Frame') == 1)
        StopCycle = 1;
    end  
end

% Index of the data
DataIndex = 1;
while(feof(oldfileFP) == 0)
    
    % Reads the next line
    Line = fgetl(oldfileFP);
    
    % Updates the output
    if (length(Line) > 4 && strcmpi(Line(1:5),'Frame') == 0)
        
        % Transforms the data into numbers
        NumDataFP = str2num(Line);
        
        % Defines some parameters that depend on the structure of the input
        % file
        DataFP(DataIndex,:) = NumDataFP;
        
        % Updates the index
        DataIndex = DataIndex + 1;
    end   
end

%%SINCRONIZATION

times=DataFP(:,1)*(1/FreqR);
spline_RFx2=spline(times,DataFP(:,8)); %Raw Data
spline_TFx2=spline(FPData(:,2),FPData(:,3)); %Treat Data

TimeSplineR=(0:0.011:10);
TimeSpline=(FPData(1,2):0.011:FPData(end,2));

ResampleRawData=ppval(spline_RFx2,TimeSplineR);
ResampleProcData=ppval(spline_TFx2,TimeSpline);

figure
 plot(TimeSplineR,ResampleRawData); hold on
 plot(TimeSpline,ResampleProcData);
  xlabel('s')
 ylabel('N')
 legend('Forceplates raw data','Treat kinematic data')
 title('UnSyncronize Force')
 
[D]=SyncSignals(ResampleRawData,ResampleProcData);

sync=TimeSpline(1)-D*0.011;

figure
 plot(TimeSplineR+sync,ResampleRawData); hold on
 plot(TimeSpline,ResampleProcData);
 xlabel('s')
 ylabel('N')
legend('Forceplates raw data','Treat kinematic data')
 title('Syncronize Force')
 %oispline=spline(times+sync,DataFP(:,8));
 %plot(times+sync,ppval(oispline,times+sync))
% %finds Max and min of splines
% [maximaT, minimaT] = splineMaximaMinima(spline_TFx2);
% [maximaR, minimaR] = splineMaximaMinima(spline_RFx2);
% 
% %find global minimum
% [Min_spline_T,indexT]=min(ppval(spline_TFx2,minimaT));
% syncT=minimaT(indexT);
% 
% [Min_spline_R,indexR]=min(ppval(spline_RFx2,minimaR));
% syncR=minimaR(indexR);

%finds syncronization time
%sync=syncR-syncT;

%%FINDS TIME FRAMES
NFrames=0;

for k=1:length(DataFP(:,1))
    %check where the FIRST contact with force plate is
    testNull=any(DataFP(k,2:(end-1))); 
    cheackNull = all(testNull==0); 
    if testNull==1
        fst_frame=k;
        break 
    end 
end

 stopcicle=0;stopcicle2=0;
for kk=fst_frame:length(DataFP(:,1))
    %check where the contact with first plate ends
     testNull1=any(DataFP(kk,2:7));
     
     if testNull1==0 && stopcicle==0
         lst_contact1=kk;
         stopcicle=1;
     end
     %check where the contact with second plate begings
     testNull2=any(DataFP(kk,8:13));
     if testNull2==1 && stopcicle2==0
         fst_contact2=kk;
         stopcicle2=1;
     end
end

for h=1:length(DataFP(:,1))
   %check where the LAST contact with force plate is
    indx=length(DataFP(:,1))-h;
    testNull=any(DataFP(indx,2:(end-1))); 
    cheackNull = all(testNull==0); 
    if testNull==1
        last_frame=indx;
        break 
    end
end

fst_time=times(fst_frame);
last_time=times(last_frame);
fst_contact1=times(lst_contact1);
lst_contact2=(fst_contact2);

fst_timeS=times(fst_frame)+sync;
last_timeS=times(last_frame)+sync;
lst_contact1S=times(lst_contact1)+sync;
fst_contact2S=times(fst_contact2)+sync;

%Create Splines
for ff=2:7
    splineAux=spline(times+sync,DataFP(:,ff)); %Raw Data
    splineFP1(ff)=splineAux;
end

for qq=2:7
    splineAux2=spline(times+sync,DataFP(:,qq+6)); %Raw Data
    splineFP2(qq)=splineAux2;
end

 

% figure
% plot(times-sync,ppval(splineFP2(2),times-sync))
% hold on
% plot(times-sync,DataFP(:,8))
