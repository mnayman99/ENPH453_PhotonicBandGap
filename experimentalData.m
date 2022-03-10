%% Clearing Memory
%clc
%close all force
diary('off')
%fclose('all') ;

%% Bringing in experimental data
calibrationData = cleanData('Data\Calibration300');
ABData = cleanData('Data\AB300');

ABData(:,2) = ABData(:,2) ./ calibrationData(:,2);
ABWindowed = movmean(ABData(:,2),20);

[ABP, ABPLocs] = findpeaks(ABWindowed, ABData(:,1),'MinPeakDistance',50e6);
fPAB = ABPLocs/1e6;
[ABT, ABTLocs] = findpeaks(-ABWindowed, ABData(:,1), 'MinPeakDistance',50e6);
ABT = -ABT;
fTAB = ABTLocs/1e6;

%% Plotting
set(0,'units','pixels') ;
SS = get(0,'screensize') ;
H = 800-90 ;
W = 1050 ;
Xpos = floor((SS(3)-W)/2) ;
Ypos = floor((SS(4)-H)/2) ;
figure('Position',[Xpos,Ypos,W,H]) ;
hold on

% Curves to plot
plot(ABData(:,1)/1e6,ABData(:,2),'r.','LineWidth',1,'DisplayName','AB')
plot(ABData(:,1)/1e6,ABWindowed,'r-','LineWidth',1,'DisplayName','AB')
plot(fPAB, ABP, 'ko', fTAB, ABT, 'ko')
%plot(ACData(:,1)/1e6,ACData(:,2),'b-','LineWidth',2,'DisplayName','AC')