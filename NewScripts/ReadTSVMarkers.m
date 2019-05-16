function [OrganizedData, UpdatedDictionary] = ReadTSVMarkers(FileName, UpdatedDictionary)
% This function reads the position data from the markers.

% Opens the file to be read
fid = fopen(FileName);

% Stopping criteria
StopCycle = 0;

%% Reads the data until finding the line starting with "Frame	Time	"
while (StopCycle == 0)
    
    % Reads the next line
    Line = fgetl(fid);
    
    % If the line starts with Marker_Names, I will keep the description of
    % the markers
    if (length(Line) > 8 && strcmpi(Line(1:9),'FREQUENCY') == 1)
        % Reads the frequency of the data
        Frequency = sscanf(Line,'FREQUENCY %d');
    elseif (length(Line) > 7 && strcmpi(Line(1:8),'MARKER_N') == 1)
       Markers = textscan(Line,'%s','Delimiter','	');
       StopCycle = 1;
    end
    
end
Markers = Markers{:}';

% Number of Markers
NMarkers = length(Markers) - 1;

%% Reads the rest of the data

% Allocates memory for the output
Data = zeros(10000, NMarkers * 3 + 2);

% Index of the data
DataIndex = 1;

while(feof(fid) == 0)
    
    % Reads the next line
    Line = fgetl(fid);
    
    % Updates the output
    if (length(Line) > 4 && strcmpi(Line(1:5),'Frame') == 0)
        
        % Transforms the data into numbers
        NumData = str2num(Line);
        
        % Defines some parameters that depend on the structure of the input
        % file
        if (DataIndex == 1)
            if (length(NumData) == (NMarkers * 3 + 2))
                TimeFramesIncluded = 1;
            else
                TimeFramesIncluded = 0;
            end
        end
        
        if (TimeFramesIncluded == 1)
            Data(DataIndex,:) = NumData;
        else
            Data(DataIndex,:) = [DataIndex, (DataIndex - 1) / Frequency, NumData];
        end
        
        % Updates the index
        DataIndex = DataIndex + 1;
    end
    
end
% Deletes the memory not used
Data(DataIndex:end,:) = [];

% Closes the file
fclose(fid);

%% Organizes the data into a structure
OrganizedData = struct;
OrganizedData.Frequency = Frequency;
OrganizedData.Markers = Markers(2:end);
OrganizedData.AbsoluteFrameTime = Data(:,1:2);
OrganizedData.NormFrameTime = Data(:,1:2);
OrganizedData.Coordinates = Data(:,3:end) / 1e3;

% Normalizes the frame and time data
OrganizedData.NormFrameTime(:,1) = OrganizedData.NormFrameTime(:,1) - OrganizedData.NormFrameTime(1,1) + 1;
OrganizedData.NormFrameTime(:,2) = OrganizedData.NormFrameTime(:,2) - OrganizedData.NormFrameTime(1,2);

%% Standardizes the name of the markers to ease their identification
if (strcmpi(UpdatedDictionary.Model,'UpperLimbModel') == 1)
    % Known names
    KnownDictionary = {'IJ', 'C7', 'T8', 'PX', 'ChangedIJ', 'SC', 'AC', 'PC',...
        'TS', 'AI', 'AA', 'SS', 'AMC1', 'AMC2', 'AMC3', 'HC1','HC2', 'HC3',...
        'HC4', 'EL', 'EM', 'US', 'RS'};
    % The description of the markers must have the same order as the dictionary
    MarkersDescript = {'IJ, Incisura Jugularis', 'C7, 7th cervical',...
        'T8, 8th Thoracic', 'PX, Processus Xiphoideus', 'ChangedIJ, Changed position of Incisura Jugularis',...
        'SC, Sternoclavicular joint', 'AC, Acromioclavicular joint',...
        'PC, Processus Coracoid', 'TS, Trigonum spinae', 'AI, Angulus inferior',...
        'AA, Angulus acromialis', 'SS, Additional marker for correction of scapula trajectory',...
        'AMC1, Cluster 1 of the acromion cluster', 'AMC2, Cluster 2 of the acromion cluster',...
        'AMC3, Cluster 3 of the acromion cluster', 'HC1, Cluster 1 of the humerus cluster',...
        'HC2, Cluster 2 of the humerus cluster', 'HC3, Cluster 3 of the humerus cluster',...
        'HC4, Cluster 4 of the humerus cluster', 'EL, Lateral epycondile',...
        'EM, Medial epycondile', 'US, Ulnar styloid', 'RS, Radial styloid'};
elseif (strcmpi(UpdatedDictionary.Model,'LowerLimbModel') == 1)
    % Known names
    KnownDictionary = {'ASIS_R', 'ASIS_L', 'PSIS_R', 'PSIS_L', 'Hip_Joint_R',...
        'Hip_Joint_L', 'Knee_Medial_R', 'Knee_Lateral_R',...
        'Malleolus_Medial_R', 'Malleolus_Lateral_R', 'Calcaneous_R',...
        'Metatarsal_I_R', 'Metatarsal_V_R', 'Hallux_R', 'Knee_Medial_L',...
        'Knee_Lateral_L', 'Malleolus_Medial_L', 'Malleolus_Lateral_L',...
        'Calcaneous_L', 'Metatarsal_I_L', 'Metatarsal_V_L', 'Hallux_L'};
    % The description of the markers must have the same order as the dictionary
    MarkersDescript = {'ASIS R, Right anterior superior iliac spine',...
        'ASIS L, Left anterior superior iliac spine',...
        'PSIS R, Right posterior superior iliac spine',...
        'PSIS L, Left posterior superior iliac spine',...
        'Hip Joint R, Right hip marker',...
        'Hip Joint L, Left hip marker',...
        'Knee Medial R, Right medial femur epycondile',...
        'Knee Lateral R, Right lateral femur epycondile',...
        'Malleolus Medial R, Right medial malleolus',...
        'Malleolus Lateral R, Right lateral malleolus',...
        'Calcaneous R, Right heel',...
        'Metatarsal I R, Right 1st metatarsus',...
        'Metatarsal V R, Right 5th metatarus',...
        'Hallux R, Right hallux',...
        'Knee Medial L, Left medial femur epycondile',...
        'Knee Lateral L, Left lateral femur epycondile',...
        'Malleolus Medial L, Left medial malleolus',...
        'Malleolus Lateral L, Left lateral malleolus',...
        'Calcaneous L, Left heel',...
        'Metatarsal I L, Left 1st metatarsus',...
        'Metatarsal V L, Left 5th metatarus',...
        'Hallux L, Left hallux'};
else
    disp('Error: Model not identified');
end

% Number of markers dscriptions
NDescript = length(MarkersDescript);

% for i = 1 : NMarkers
%     
%     % Checks if the name is in the dictionary
%     MarkerPos = find(strcmpi(OrganizedData.Markers(i),KnownDictionary), 1);
%     
%     % If it finds, the name is fine. If it does not find, I have to ask
%     % what marker it is
%     if (isempty(MarkerPos) == 1)
%         
%         % Checks the updated dictionary
%         MarkerPosUpdate = find(strcmpi(OrganizedData.Markers(i), UpdatedDictionary.MarkersName), 1);
%         
%         % If it finds, the name is fine. If it does not find, I have to ask
%         % what marker it is
%         if (isempty(MarkerPosUpdate) == 1)
%             for j = 1 : NDescript
%                 disp([num2str(j),' - ',char(MarkersDescript(j))]);
%             end
%             disp([num2str(NDescript + 1), ' - This marker is not needed']);
%             disp(['The current marker (',char(OrganizedData.Markers(i)),') is not known']);
%             MarkerCor = input('What is its number?\n');
%         
%             % Updates the name of the maker according to its position and
%             % updates the updatedDictionary
%             UpdatedDictionary.MarkersName(end + 1) = OrganizedData.Markers(i);
%             if (MarkerCor == (NDescript + 1))
%                 OrganizedData.Markers(i) = {'NotInList'};
%                 UpdatedDictionary.MarkersModel(end + 1) = {'NotInList'};
%             else
%                 OrganizedData.Markers(i) = KnownDictionary(MarkerCor);
%                 UpdatedDictionary.MarkersModel(end + 1) = KnownDictionary(MarkerCor);
%             end
%         else
%             OrganizedData.Markers(i) = UpdatedDictionary.MarkersModel(MarkerPosUpdate);
%         end
%     end
%    
% end
clc;
% End of function
end