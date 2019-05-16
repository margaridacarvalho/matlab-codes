ForcePlate= dlmread('calib0002_RS3_f_3.tsv','	',25,0);

DataFPraw=dlmread('K5R_110323_1_022_forceplate_raw.csv',',',13,0);
DataFPproc=dlmread('K5R_110323_1_022_level_walk.csv',',',16,0);

Freq=100;
tm=(1:1:length(ForcePlate(:,1)))*(1/Freq);

ForcePlate(:,1)=[];
ForcePlate(:,1)=[];

figure

subplot(3,3,1);
plot(tm,ForcePlate(:,1))
title('Fx')

subplot(3,3,2);
plot(tm,ForcePlate(:,2))
title('Fy')

subplot(3,3,3);
plot(tm,ForcePlate(:,3))
title('Fz')

subplot(3,3,4);
plot(tm,ForcePlate(:,4))
title('Mx')

subplot(3,3,5);
plot(tm,ForcePlate(:,5))
title('My')

subplot(3,3,6);
plot(tm,ForcePlate(:,6))
title('Mz')

subplot(3,3,7);
plot(tm,ForcePlate(:,7))
title('COPx')

subplot(3,3,8);
plot(tm,ForcePlate(:,8))
title('COPy')

subplot(3,3,9);
plot(tm,ForcePlate(:,9))
title('COPz')
