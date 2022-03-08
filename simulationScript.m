%% Clearing Memory
clc
close all force
diary('off')
fclose('all') ;

%% Parameter definitions
f = linspace(63e6,1544e6,2001);
c = 2.998e8;

%% Definitions for each coax cable
% RG-58
Z1 = 50;
v1 = 0.659*c;
l1 = 0.2;
l1unc = 0.005;

% RG-59
Z2 = 75.3;
v2 = 0.66*c;
l2 = 0.2;
l2unc = 0.005;

% RG-62
Z3 = 93;
v3 = 0.83*c;
l3 = 0.2;
l3unc = 0.005;

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

    M2 = generateMatrix(Z2,Z3,f(i),v2,l2,v3,l3);
    M2Up = generateMatrix(Z2,Z3,f(i),v2,l2 + l2unc,v3,l3 + l3unc);
    M2Down = generateMatrix(Z2,Z3,f(i),v2,l2 - l2unc,v3,l3 - l3unc);
    MT = M2*M1;
    MTUp = M2Up*M1Up;
    MTDown = M2Down*M1Down;
    R2(i) = abs(MT(2,1))^2/(abs(MT(1,1))^2);
    R2Up(i) = abs(MTUp(2,1))^2/(abs(MTUp(1,1))^2);
    R2Down(i) = abs(MTDown(2,1))^2/(abs(MTDown(1,1))^2);
end

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
plot(f/1e6,R1Up,'b--','LineWidth',2,'DisplayName','Z1-Z2 Simulation Error')
plot(f/1e6,R1,'b-','LineWidth',2,'DisplayName','Z1-Z2')
plot(f/1e6,R2Up,'r--','LineWidth',2,'DisplayName','Z1-Z2-Z3 Simulation Error')
plot(f/1e6,R2,'r-','LineWidth',2,'DisplayName','Z1-Z2-Z3')
legend('Location','northeastoutside', 'FontSize',11, 'AutoUpdate', 'off')

plot(f/1e6,R1Down,'b--','LineWidth',2,'DisplayName','Z1-Z2 Lower Bound')
plot(f/1e6,R2Down,'r--','LineWidth',2,'DisplayName','Z1-Z2-Z3 Lower Bound')

% Making plot pretty

xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('R', 'FontSize',12)
grid on
