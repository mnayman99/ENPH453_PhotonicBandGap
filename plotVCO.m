data = xlsread("Data\Mar10_InputVolts_OutputFrequency.xlsx",1,'B3:F18');

set(0,'units','pixels') ;
SS = get(0,'screensize') ;
H = 800-90 ;
W = 1050 ;
Xpos = floor((SS(3)-W)/2) ;
Ypos = floor((SS(4)-H)/2) ;
figure('Position',[Xpos,Ypos,W,H]) ;
hold on

plot(data(:,1),data(:,2), '*-','LineWidth',1, 'DisplayName','VCO1')
plot(data(:,1),data(:,3), '*-','LineWidth',1, 'DisplayName','VCO2')
plot(data(:,1),data(:,4), '*-','LineWidth',1, 'DisplayName','VCO3')
plot(data(:,1),data(:,5), '*-','LineWidth',1, 'DisplayName','VCO4')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')

grid on
ylabel('Frequency [MHz]')
xlabel('Input LabVIEW Voltage [V]')