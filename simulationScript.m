%% Clearing Memory
clc
close all force
diary('off')
fclose('all') ;

%% Parameter definitions
f = linspace(0,375e6,1001);
c = 2.998e8;

%% Definitions for each coax cable
% RG-58
Z1 = 50;
v1 = 0.659*c;
l1 = 0.216;
l1unc = 0.002;

% RG-59
Z2 = 75.3;
v2 = 0.66*c;
l2 = 0.719;
l2unc = 0.002;

% RG-62
Z3 = 93;
v3 = 0.83*c;
l3 = 1.541;
l3unc = 0.002;

R1 = zeros(1,length(f));
R1Up = zeros(1,length(f));
R1Down = zeros(1,length(f));
R2 = zeros(1,length(f));
R2Up = zeros(1,length(f));
R2Down = zeros(1,length(f));

%% Simulation(s) of coax cables for the provided frequency range
for i=1:length(f)
    M1 = generateMatrix(Z1,Z2,f(i),v1,l1,v2,l2);
    M1Up = generateMatrix(Z1,Z2,f(i),v1,l1 + l1unc,v2,l2 + l2unc);
    M1Down = generateMatrix(Z1,Z2,f(i),v1,l1 - l1unc,v2,l2 - l2unc);
    R1(i) = abs(M1(2,1))^2/(abs(M1(1,1))^2);
    R1Up(i) = abs(M1Up(2,1))^2/(abs(M1Up(1,1))^2);
    R1Down(i) = abs(M1Down(2,1))^2/(abs(M1Down(1,1))^2);

    M2 = generateMatrix(Z1,Z3,f(i),v1,l1,v3,l3);
    M2Up = generateMatrix(Z1,Z3,f(i),v1,l1 + l1unc,v3,l3 + l3unc);
    M2Down = generateMatrix(Z1,Z3,f(i),v1,l1 - l1unc,v3,l3 - l3unc);
    R2(i) = abs(M2(2,1))^2/(abs(M2(1,1))^2);
    R2Up(i) = abs(M2Up(2,1))^2/(abs(M2Up(1,1))^2);
    R2Down(i) = abs(M2Down(2,1))^2/(abs(M2Down(1,1))^2);
end

[R1Peaks, R1PLocs] = findpeaks(R1);
fPR1 = f(R1PLocs)/1e6;
[R1Troughs, R1TLocs] = findpeaks(-R1);
R1Troughs = -R1Troughs;
fTR1 = f(R1TLocs)/1e6;

[R2Peaks, R2PLocs] = findpeaks(R2);
fPR2 = f(R2PLocs)/1e6;
[R2Troughs, R2TLocs] = findpeaks(-R2);
R2Troughs = -R2Troughs;
fTR2 = f(R2TLocs)/1e6;
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
plot(f/1e6,R1Up,'b--','LineWidth',1,'DisplayName','AB Simulation Error')
plot(f/1e6,R1,'b-','LineWidth',1,'DisplayName','AB')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')
plot(fPR1, R1Peaks, 'ko', fTR1, R1Troughs, 'ko', 'LineWidth', 2)
plot(f/1e6,R1Down,'b--','LineWidth',1)
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('R', 'FontSize',12)
grid on

figure('Position',[Xpos,Ypos,W,H]) ;
hold on
plot(f/1e6,R2Up,'r--','LineWidth',1,'DisplayName','AC Simulation Error')
plot(f/1e6,R2,'r-','LineWidth',1,'DisplayName','AC')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')
plot(fPR2, R2Peaks, 'ko', fTR2, R2Troughs, 'ko', 'LineWidth', 2)
plot(f/1e6,R2Down,'r--','LineWidth',1)
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('R', 'FontSize',12)
grid on
