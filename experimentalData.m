%% Clearing Memory
%clc
close all force
diary('off')
%fclose('all') ;

%% Bringing in experimental data
calibrationData = cleanData('Data\Calibration300');
ABData = cleanData('Data\AB300');
ACData = cleanData('Data\AC300');

ABData(:,2) = ABData(:,2) ./ calibrationData(:,2);
ABWindowed = movmean(ABData(:,2),21);

[ABP, ABPLocs] = findpeaks(ABWindowed, ABData(:,1),'MinPeakDistance',50e6);
fPAB = ABPLocs/1e6;
ABPIdx = find(ismember(ABData(:,1), ABPLocs'))';
fPABError = zeros(1,length(fPAB));
for i=1:length(fPAB) - 1
    fPABError(i) = 10*mean(diff(ABData(ABPIdx(i)-10:ABPIdx(i)+10,1)));
end
fPABError(end) = 10*mean(diff(ABData(ABPIdx(end)-10:ABPIdx(end),1)));

[ABT, ABTLocs] = findpeaks(-ABWindowed, ABData(:,1), 'MinPeakDistance',50e6);
ABT = -ABT;
fTAB = ABTLocs/1e6;
ABTIdx = find(ismember(ABData(:,1), ABTLocs'))';
fTABError = zeros(1,length(fTAB));
for i=1:length(fTAB) - 1
    fTABError(i) = 10*mean(diff(ABData(ABTIdx(i)-10:ABTIdx(i)+10,1)));
end
fTABError(end) = 10*mean(diff(ABData(ABTIdx(end)-10:ABTIdx(end),1)));

meanPABsep = mean(diff(fPAB));
meanPABError = sqrt(sum(fPABError.^2));
meanTABsep = mean(diff(fTAB(2:end)));
meanTABError = sqrt(sum(fTABError(2:end).^2));
PABDiffs = diff(fPAB);
PABDiffsError = sqrt(fPABError(1:end-1).^2 + fPABError(2:end).^2);
TABDiffs = diff(fTAB(2:end));
TABDiffsError = sqrt(fTABError(1:end-1).^2 + fTABError(2:end).^2);

ACData(:,2) = ACData(:,2) ./ calibrationData(:,2);
ACWindowed = movmean(ACData(:,2),21);

[ACP, ACPLocs] = findpeaks(ACWindowed, ACData(:,1),'MinPeakDistance',50e6);
fPAC = ACPLocs/1e6;
ACPIdx = find(ismember(ACData(:,1), ACPLocs'))';
fPACError = zeros(1,length(fPAC));
for i=1:length(fPAC) - 1
    fPACError(i) = 10*mean(diff(ACData(ACPIdx(i)-10:ACPIdx(i)+10,1)));
end
fPACError(end) = 10*mean(diff(ACData(ACPIdx(end)-10:ACPIdx(end),1)));

[ACT, ACTLocs] = findpeaks(-ACWindowed, ACData(:,1), 'MinPeakDistance',50e6);
ACT = -ACT;
fTAC = ACTLocs/1e6;
ACTIdx = find(ismember(ACData(:,1), ACTLocs'))';
fTACError = zeros(1,length(fTAC));
for i=1:length(fTAC) - 1
    fTACError(i) = 10*mean(diff(ACData(ACTIdx(i)-10:ACTIdx(i)+10,1)));
end
fTACError(end) = 10*mean(diff(ACData(ACTIdx(end)-10:ACTIdx(end),1)));

meanPACsep = mean(diff(fPAC));
meanPACError = sqrt(sum(fPACError.^2));
meanTACsep = mean(diff(fTAC(2:end)));
meanTACError = sqrt(sum(fTACError(2:end).^2));
PACDiffs = diff(fPAC);
PACDiffsError = sqrt(fPACError(1:end-1).^2 + fPACError(2:end).^2);
TACDiffs = diff(fTAC(2:end));
TACDiffsError = sqrt(fTACError(1:end-1).^2 + fTACError(2:end).^2);

%% Plotting
set(0,'units','pixels') ;
SS = get(0,'screensize') ;
H = 800-90 ;
W = 1050 ;
Xpos = floor((SS(3)-W)/2) ;
Ypos = floor((SS(4)-H)/2) ;

% Curves to plot
figure('Position',[Xpos,Ypos,W,H]) ;
hold on
plot(ABData(:,1)/1e6,ABData(:,2),'b.','LineWidth',2,'DisplayName','AB Raw')
plot(ABData(:,1)/1e6,ABWindowed,'b-','LineWidth',1,'DisplayName','AB Averaged')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')
plot(fPAB, ABP, 'ko', fTAB(2:end), ABT(2:end), 'ko', 'LineWidth',2)
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('VOut/VCalibration', 'FontSize',12)
grid on

figure('Position',[Xpos,Ypos,W,H]) ;
hold on
plot(ACData(:,1)/1e6,ACData(:,2),'r.','LineWidth',2,'DisplayName','AC Raw')
plot(ACData(:,1)/1e6,ACWindowed,'r-','LineWidth',1,'DisplayName','AC Averaged')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')
plot(fPAC, ACP, 'ko', fTAC(2:end), ACT(2:end), 'ko', 'LineWidth',2)
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('VOut/VCalibration', 'FontSize',12)
grid on

figure('Position',[Xpos,Ypos,W,H]) ;
hold on
plot(calibrationData(:,1)/1e6,calibrationData(:,2),'k.','LineWidth',2,'DisplayName','AC Raw')
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('VOut [V]', 'FontSize',12)
grid on