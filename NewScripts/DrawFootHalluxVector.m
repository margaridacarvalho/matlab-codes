% figure
% for i=1:122
% %       fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,43*3-2),KineMarkers(t,43*3-1)+10,KineMarkers(t,43*3)); %Right Hallux
% %         fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,39*3-2),KineMarkers(t,39*3-1)+10, KineMarkers(t,39*3)); %Left Hallux
% 
%     RMET01=[ValMark(i,43*3-1) ValMark(i,43*3)]; %RMET01
%     RMET05=[ValMark(i,44*3-1) ValMark(i,44*3)]; %RMET05
%     RHEEL=[ValMark(i,46*3-1) ValMark(i,46*3)]; %RHEEL
%     RLCO=[ValMark(i,22*3-1) ValMark(i,22*3)]; %RLCO
%     RMCO=[ValMark(i,21*3-1) ValMark(i,21*3)]; %RMCO
%     RLMA=[ValMark(i,38*3-1) ValMark(i,38*3)]; %RLMA
%     RLMA=[ValMark(i,37*3-1) ValMark(i,37*3)]; %RMMA
%     HL=[ValMark(i,43*3-1)+20 ValMark(i,43*3)]; %RHALLUX
% 
% plot([ValMark(i,43*3-1) ValMark(i,46*3-1)],[ValMark(i,43*3) ValMark(i,46*3)],'r',...
%     [ValMark(i,46*3-1) ValMark(i,38*3-1)],[ValMark(i,46*3) ValMark(i,38*3)],'r',...
%     [ValMark(i,38*3-1) ValMark(i,43*3-1)],[ValMark(i,38*3) ValMark(i,43*3)],'r',...
%      [ValMark(i,38*3-1) ValMark(i,22*3-1)],[ValMark(i,38*3) ValMark(i,22*3)],'r',...
%     [ValMark(i,43*3-1) ValMark(i,43*3-1)+50],[ValMark(i,43*3) ValMark(i,43*3)],'r');
% hold on
% end

figure
for i=1:20:120
%       fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,43*3-2),KineMarkers(t,43*3-1)+10,KineMarkers(t,43*3)); %Right Hallux
%         fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,39*3-2),KineMarkers(t,39*3-1)+10, KineMarkers(t,39*3)); %Left Hallux

plot3([ValMark(i,43*3-2) ValMark(i,44*3-2)],[ValMark(i,43*3-1) ValMark(i,44*3-1)],[ValMark(i,43*3) ValMark(i,44*3)],'r',... %MET01 TO MET05
    [ValMark(i,46*3-2) ValMark(i,44*3-2)],[ValMark(i,46*3-1) ValMark(i,44*3-1)],[ValMark(i,46*3) ValMark(i,44*3)],'r',... %MET05 TO HEEL
    [ValMark(i,46*3-2) ValMark(i,43*3-2)],[ValMark(i,46*3-1) ValMark(i,43*3-1)],[ValMark(i,46*3) ValMark(i,43*3)],'r',... %MET01 TO HEEL
    [ValMark(i,46*3-2) ValMark(i,37*3-2)],[ValMark(i,46*3-1) ValMark(i,37*3-1)],[ValMark(i,46*3) ValMark(i,37*3)],'b',... %RMMA TO HEEL
    [ValMark(i,37*3-2) ValMark(i,21*3-2)],[ValMark(i,37*3-1) ValMark(i,21*3-1)],[ValMark(i,37*3) ValMark(i,21*3)],'b',... %RMMA TO RMCO
    [ValMark(i,43*3-2) ValMark(i,43*3-2)],[ValMark(i,43*3-1) ValMark(i,43*3-1)+50],[ValMark(i,43*3) ValMark(i,43*3)],'g'); %HAMLLUX
hold on
end
%     [ValMark(i,46*3-2) ValMark(i,38*3-2)],[ValMark(i,46*3-1) ValMark(i,38*3-1)],[ValMark(i,46*3) ValMark(i,38*3)],'b',... %RLMA TO HEEL
%     [ValMark(i,38*3-2) ValMark(i,22*3-2)],[ValMark(i,38*3-1) ValMark(i,22*3-1)],[ValMark(i,38*3) ValMark(i,22*3)],'b',... %RLMA TO RLCO
figure
load('SavePos13.mat')
%SavePos13(i,6*7-5)*10^3
for i=1:20:120
%       fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,43*3-2),KineMarkers(t,43*3-1)+10,KineMarkers(t,43*3)); %Right Hallux
%         fprintf(fileID,'%3.3f	%3.3f	%3.3f	',KineMarkers(t,39*3-2),KineMarkers(t,39*3-1)+10, KineMarkers(t,39*3)); %Left Hallux

plot3([ValMark(i,43*3-2) ValMark(i,44*3-2)],[ValMark(i,43*3-1) ValMark(i,44*3-1)],[ValMark(i,43*3) ValMark(i,44*3)],'r',... %MET01 TO MET05
    [ValMark(i,46*3-2) ValMark(i,44*3-2)],[ValMark(i,46*3-1) ValMark(i,44*3-1)],[ValMark(i,46*3) ValMark(i,44*3)],'r',... %MET05 TO HEEL
    [ValMark(i,46*3-2) ValMark(i,43*3-2)],[ValMark(i,46*3-1) ValMark(i,43*3-1)],[ValMark(i,46*3) ValMark(i,43*3)],'r',... %MET01 TO HEEL
    [ValMark(i,46*3-2) ValMark(i,37*3-2)],[ValMark(i,46*3-1) ValMark(i,37*3-1)],[ValMark(i,46*3) ValMark(i,37*3)],'b',... %RMMA TO HEEL
    [ValMark(i,37*3-2) ValMark(i,21*3-2)],[ValMark(i,37*3-1) ValMark(i,21*3-1)],[ValMark(i,37*3) ValMark(i,21*3)],'b',... %RMMA TO RMCO
   [ValMark(i,43*3-2) SavePos13(i,6*7-6)*10^3],[ValMark(i,43*3-1) SavePos13(i,6*7-5)*10^3],[ValMark(i,43*3) SavePos13(i,6*7-4)*10^3],'b') %HAMLLUX
hold on
plot3([SavePos13(i,2*7-6)*10^3 SavePos13(i,4*7-6)*10^3],[SavePos13(i,2*7-5)*10^3  SavePos13(i,4*7-5)*10^3],[SavePos13(i,2*7-4)*10^3  SavePos13(i,4*7-4)*10^3],'g',...
    [SavePos13(i,4*7-6)*10^3 SavePos13(i,5*7-6)*10^3],[SavePos13(i,4*7-5)*10^3  SavePos13(i,5*7-5)*10^3],[SavePos13(i,4*7-4)*10^3  SavePos13(i,5*7-4)*10^3],'g',...
    [SavePos13(i,5*7-6)*10^3 SavePos13(i,6*7-6)*10^3],[SavePos13(i,5*7-5)*10^3  SavePos13(i,6*7-5)*10^3],[SavePos13(i,5*7-4)*10^3  SavePos13(i,6*7-4)*10^3],'g')

end