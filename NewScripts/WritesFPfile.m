 function WritesFPfile(splinefunction,np,NFrames,ftimes)
%Writes force plates .tsv file

%%WRITES FILE
global Freq 

if np==1
    FPX1=400;FPY1=600;FPZ1=0;
    FPX2=400;FPY2=0;FPZ2=0;
    FPX3=0;FPY3=0;FPZ3=0;
    FPX4=0;FPY4=600;FPZ4=0;
else
    FPX1=400;FPY1=1203;FPZ1=0;
    FPX2=400;FPY2=603;FPZ2=0;
    FPX3=0;FPY3=603;FPZ3=0;
    FPX4=0;FPY4=1203;FPZ4=0;
end

Fx=zeros(NFrames,1);
Fy=zeros(NFrames,1);
Fz=zeros(NFrames,1);
Mx=zeros(NFrames,1);
My=zeros(NFrames,1);
Mz=zeros(NFrames,1);
COPx=zeros(NFrames,1);
COPy=zeros(NFrames,1);


FPLength=400;
FPWidth=600;

% ofsetx=1;
% ofsety=2;
% ofsetz=3;

filename = sprintf('0905_f_%i.tsv', np);
 
fileID = fopen(filename,'w');
fprintf(fileID,'NO_OF_SAMPLES	%d\r\n',NFrames);
fprintf(fileID,'FREQUENCY	%3.6f\r\n', Freq);
fprintf(fileID,'TIME_STAMP	\r\n'); %falta
fprintf(fileID,'FIRST_SAMPLE	7853\r\n'); %falta
fprintf(fileID,'DESCRIPTION	Force data in local (force plate) coordinates\r\n');
fprintf(fileID,'DATA_INCLUDED	Force\r\n');
fprintf(fileID,'FORCE_PLATE_TYPE	Amti\r\n');
fprintf(fileID,'FORCE_PLATE_MODEL	Unknown\r\n');
fprintf(fileID,'FORCE_PLATE_NAME	Force-plate 1\r\n'); %MUDAR
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_POSY_X	%3.3f\r\n',FPX1);
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_POSY_Y	%3.3f\r\n',FPY1);
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_POSY_Z	%3.3f\r\n',FPZ1);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_POSY_X	%3.3f\r\n',FPX2);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_POSY_Y	%3.3f\r\n',FPY2);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_POSY_Z	%3.3f\r\n',FPZ2);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_NEGY_X	%3.3f\r\n',FPX3);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_NEGY_Y	%3.3f\r\n',FPY3);
fprintf(fileID,'FORCE_PLATE_CORNER_NEGX_NEGY_Z	%3.3f\r\n',FPZ3);
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_NEGY_X	%3.3f\r\n',FPX4);
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_NEGY_Y	%3.3f\r\n',FPY4);
fprintf(fileID,'FORCE_PLATE_CORNER_POSX_NEGY_Z	%3.3f\r\n',FPZ4);
fprintf(fileID,'FORCE_PLATE_LENGTH	%3.3f\r\n',FPLength);
fprintf(fileID,'FORCE_PLATE_WIDTH	%3.3f\r\n',FPWidth);
fprintf(fileID,'Force_X	Force_Y	Force_Z	Moment_X	Moment_Y	Moment_Z	COP_X	COP_Y	COP_Z\r\n');
for q=1:NFrames
    
    %fprintf(fileID,'%3.3f	',q );
    %fprintf(fileID,'%3.3f	',ftimes(q,1));
    %force and moments
     
    Fz(q)= -ppval(splinefunction(4),ftimes(q));
    Mz(q)= -ppval(splinefunction(7),ftimes(q))*10^-3;
    
    if np==1
        Fx(q)= -ppval(splinefunction(2),ftimes(q));
        Fy(q)= ppval(splinefunction(3),ftimes(q));
        Mx(q)= -ppval(splinefunction(5),ftimes(q))*10^-3;
        My(q)= ppval(splinefunction(6),ftimes(q))*10^-3;
    else
        Fx(q)= ppval(splinefunction(2),ftimes(q));
        Fy(q)= -ppval(splinefunction(3),ftimes(q));
        Mx(q)= ppval(splinefunction(5),ftimes(q))*10^-3;
        My(q)= -ppval(splinefunction(6),ftimes(q))*10^-3;
    end
    
    fprintf(fileID,'%3.3f	%3.3f	%3.3f	', Fx(q), Fy(q), Fz(q));
    fprintf(fileID,'%3.3f	%3.3f	%3.3f	', Mx(q), My(q), Mz(q));
    %COPS
    COPx(q)=-My(q)/Fz(q)*10^3;
    COPy(q)=Mx(q)/Fz(q)*10^3;
    COPz(q)=0;
    if isnan(COPx(q))==1
        COPx(q)=0;
    end
    
    if isnan(COPy(q))==1
        COPy(q)=0;
    end
    
    
    fprintf(fileID,'%3.3f	%3.3f	%3.3f	', COPx(q),COPy(q),COPz(q));
    fprintf(fileID,'\r\n');
end
fclose(fileID);

figure

subplot(3,3,1);
plot(ftimes,Fx)
title('Fx')
xlabel('s')
ylabel('N')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,2);
plot(ftimes,Fy)
title('Fy')
xlabel('s')
ylabel('N')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,3);
plot(ftimes,Fz)
title('Fz')
xlabel('s')
ylabel('N')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,4);
plot(ftimes,Mx)
title('Mx')
xlabel('s')
ylabel('Nm')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,5);
plot(ftimes, My)
title('My')
xlabel('s')
ylabel('Nm')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,6);
plot(ftimes,Mz)
title('Mz')
xlabel('s')
ylabel('Nm')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,7);
plot(ftimes,COPx)
title('COPx')
xlabel('s')
ylabel('mm')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,8);
plot(ftimes,COPy)
title('COPy')
xlabel('s')
ylabel('mm')
xlim([ftimes(1) ftimes(end)])

subplot(3,3,9);
plot(ftimes,COPz)
title('COPz')
xlabel('s')
ylabel('mm')
xlim([ftimes(1) ftimes(end)])

if np==2
load('OrtholoadProData.mat')
figure
subplot(2,2,1);
plot(ftimes,My)
hold on
plot(Data(:,1),-((Data(:,13)).*Data(:,12))/10^3)
xlabel('s')
ylabel('N')
%COPx(q)=-My(q)/Fz(q)*10^3;

subplot(2,2,2);
plot(ftimes,Fz)
hold on
plot(Data(:,1),Data(:,12))
xlabel('s')
ylabel('N')

subplot(2,2,3:4);
plot(ftimes,COPx)
hold on
plot(Data(:,1),Data(:,13)+0.381)
xlabel('s')
ylabel('N')

figure
subplot(2,2,1);
plot(ftimes,Mx)
hold on
plot(Data(:,1),((Data(:,14)).*Data(:,12))/10^3)
%COPx(q)=-My(q)/Fz(q)*10^3;

subplot(2,2,2);
plot(ftimes,Fz)
hold on
plot(Data(:,1),Data(:,12))

subplot(2,2,3:4);
plot(ftimes,COPy)
hold on
plot(Data(:,1),Data(:,14)+1.0414)

figure
plot(ftimes,COPx)
hold on
title('COPx')
plot(Data(:,1),Data(:,13))
xlabel('s')
ylabel('mm')
xlim([5.4 6.4])
end
