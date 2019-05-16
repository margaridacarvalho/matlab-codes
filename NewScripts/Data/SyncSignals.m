function [D]=SyncSignals(A,B)



% Resample signal A
% A = resample(A, Fs_B, Fs_A);

% Plot to visualize that one signal is delayed 
figure
plot(A)
hold on
plot(B)
% Aling both signals using xcorr
[C,lag] = xcorr(A,B);

figure
plot(lag,C);
 xlabel('lag (nº shifts)')
 ylabel('correlation')
 title('Cross-Correlation')
[M,I] = max(C);
D = lag(I);

%figure(3),plot(1:length(A), A, 'b',1+abs(D):length(B)+abs(D), B, 'r'), title(' "Synchronised" signals ');

%BValor=B(D);