%function RewriteOrtholoadFile(FileName)
%Addapts the ORTOLOAD data file to the Lisbon Biomechanics Lab. format

%% READS ORTHOLOAD FILE
oldfile=fopen('K5R_110323_1_022_level_walk.csv');

global Freq timestep

% Stopping criteria
StopCycle = 0;
ii=1;

% Reads the data until finding the line starting with "time''
while (StopCycle == 0)
    % Reads the next line
    Line = fgetl(oldfile);
    if (length(Line) > 8 && strcmpi(Line(1:4),'time') == 1)
        AuxCell = textscan(Line,'%s','Delimiter',',,,');
        
        for i=16:3:157 %specify?
            %Saves markers names
            Markers{1,1}{ii,1}=AuxCell{1,1}{i,1};
            ii=ii+1;
        end
        %Counts the number of markers and stops the cycle
        NMarkers = length(Markers{1,1});
        StopCycle = 1;
    end   
end

% Index of the data
DataIndex = 1;

% Reads the rest of the data
while(feof(oldfile) == 0)
    % Reads the next line
    Line = fgetl(oldfile);
    % Updates the output
    
    if (length(Line) > 4 && strcmpi(Line(1:3),'[s]') == 0)
        % Transforms the data into numbers
        NumData = str2num(Line);
        % Defines some parameters that depend on the structure of the input
        % file
        Data(DataIndex,:) = NumData;
        % Updates the index
        DataIndex = DataIndex + 1;
    end   
end

fclose(oldfile);

%% Treat data to create splines
NFramesFP=0;

for k=1:length(Data(:,1))
    %check for each line is there is contact with forceplace and 
    %all markers position
    testNaN=isnan(Data(k,2:end)); %CAREFULL only saves when there is contact with force plate
    cheackNan = all(testNaN==0);
    if cheackNan==1
        %deletes all measured frames not containing all the information
        NFramesFP=NFramesFP+1;
        ProcessedFP(NFramesFP,:)=Data(k,:);  
    end
end

% Reads FORCEPLATE data from PROCESSED FILE
%only for ipsilateral leg
NSamplesP=length(ProcessedFP(:,1));

FPData(:,:)=zeros(NSamplesP,11);

FPData(:,1)=(1:1:NSamplesP);
FPData(:,2)=ProcessedFP(:,1);
FPData(:,3:5)=ProcessedFP(:,10:12);
FPData(:,9:10)=ProcessedFP(:,13:14);

%% SINCRONIZE DATA
[fst_timeS,last_timeS,splineFP1,splineFP2,lst_contact1S,fst_contact2S]=SyncFPlateData(FPData);

%% Save data from selected time interval
[frsval,frs_frameS]= min(abs(Data(:,1)-fst_timeS));
[lstval,lst_frameS]= min(abs(Data(:,1)-last_timeS));

% NFrames=lst_frameS-frs_frameS;
TreatData=Data(frs_frameS:lst_frameS,:);
% NFrames=length(TreatData(:,1));

KineMarkers=TreatData(:,16:length(TreatData(1,:)));
 timestep=0.010;
 Freq= 1/timestep; 
 NCameras = 10;

%% Creates Splines for markers trajectories
%Create Splines
for w=1:length(KineMarkers(1,:))
    splineAux=spline(TreatData(:,1),KineMarkers(:,w)); %Raw Data
    splineKM(w)=splineAux;
end

 %global ftimes
ftimes=Data(frs_frameS,1):timestep:Data(lst_frameS,1);
NFrames=length(ftimes);

%% Writes the new KINEMATIC file
fileID = fopen('0905.tsv','w');
fprintf(fileID,'NO_OF_FRAMES	%d \r\n',NFrames);
fprintf(fileID,'NO_OF_CAMERAS	%d \r\n',NCameras);
fprintf(fileID,'NO_OF_MARKERS	%d \r\n',NMarkers);
fprintf(fileID,'FREQUENCY	%3.6f \r\n',Freq);
fprintf(fileID,'NO_OF_ANALOG	0 \r\n');
fprintf(fileID,'ANALOG_FREQUENCY	0 \r\n');
fprintf(fileID,'DESCRIPTION -- \r\n');
fprintf(fileID,'TIME_STAMP \r\n'); %falta
fprintf(fileID,'DATA_INCLUDED	3D \r\n');
fprintf(fileID,'MARKER_NAMES	');
%Writes Markers Name
for m=1:NMarkers
    fprintf(fileID,'%s	',Markers{1,1}{m,1});
end
fprintf(fileID,'Hallux_R	');%,(NMarkers+1));
fprintf(fileID,'Hallux_L	');%,(NMarkers+2));
fprintf(fileID,'\r\n');
%Writes Markers Data

for t=1:length(ftimes)
    for q=1:(3*NMarkers)
        ValMark(t,q)=ppval(splineKM(q),ftimes(t));
        fprintf(fileID,'%3.3f	',ValMark(t,q));
    end
    
        fprintf(fileID,'%3.3f	%3.3f	%3.3f	',ValMark(t,43*3-2),ValMark(t,43*3-1)+50,ValMark(t,43*3)); %Right Hallux
        fprintf(fileID,'%3.3f	%3.3f	%3.3f	',ValMark(t,39*3-2),ValMark(t,39*3-1)+50, ValMark(t,39*3)); %Left Hallux

%      load('SavePos9.mat')
% % %     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',CompletePositions(t,6*7-6)*10^3,CompletePositions(t,6*7-5)*10^3, CompletePositions(t,6*7-4)*10^3); %Right Hallux
% % %     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',CompletePositions(t,11*7-6)*10^3,CompletePositions(t,11*7-5)*10^3,CompletePositions(t,11*7-4)*10^3); %Left Hallux
%     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',SavePos9(t,6*7-1)*10^3,SavePos9(t,6*7-5)*10^3, SavePos9(t,6*7-6)*10^3); %Right Hallux
%     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',SavePos9(t,11*7-1)*10^3,SavePos9(t,11*7-5)*10^3,SavePos9(t,11*7-6)*10^3); %Left Hallux
% %     
    fprintf(fileID,'\r\n');
end

%   Fz(q)= -ppval(splinefunction(4),TreatData(q,1));

% for q=1:NFrames
%     for w=1:(3*NMarkers)
%         fprintf(fileID,'%3.3f	',KineMarkers(q,w));
%     end
%     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(q,43*3),KineMarkers(q,43*3+1),KineMarkers(q,43*3+2)); %Right Hallux
%     fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(q,39*3),KineMarkers(q,39*3+1), KineMarkers(q,39*3+2)); %Left Hallux
%     fprintf(fileID,'\r\n');
% end
fclose(fileID);

WritesFPfile(splineFP1,1,NFrames,ftimes)
WritesFPfile(splineFP2,2,NFrames,ftimes)



