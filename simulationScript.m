%% Clearing Memory
clc
close all force
diary('off')
fclose('all') ;

%% Parameter definitions
f = linspace(1000,0.5e9,1001);
c = 2.998e8;

%% Definitions for each coax cable
% RG-58
Z1 = 50;
v1 = 0.659*c;
l1 = 0.2;

% RG-59
Z2 = 75.3;
v2 = 0.66*c;
l2 = 0.2;

% RG-62
Z3 = 93;
v3 = 0.83*c;
l3 = 0.2;

%% Simulation(s) of coax cables for the provided frequency range
for i=1:length(f)
    M = generateMatrix(Z1,Z2,f(i),v1,l1,v2,l2);
    R1(i) = abs(M(2,1))^2/(abs(M(1,1))^2);
    M2 = generateMatrix(Z2,Z3,f(i),v2,l2,v3,l3);
    MT = M2*M;
    R2(i) = abs(MT(2,1))^2/(abs(MT(1,1))^2);
end

%% Plotting
set(0,'units','pixels') ;
SS = get(0,'screensize') ;
H = 800-90 ;
W = 800 ;
Xpos = floor((SS(3)-W)/2) ;
Ypos = floor((SS(4)-H)/2) ;
figure('Position',[Xpos,Ypos,W,H]) ;
hold on

% Curves to plot
plot(f/1e6,R1,'b-','LineWidth',2,'DisplayName','Z1-Z2')
plot(f/1e6,R2,'r-','LineWidth',2,'DisplayName','Z1-Z2-Z3')

% Making plot pretty
legend('Location','northeast', 'FontSize',12)
xlabel('Frequency [MHz]', 'FontSize',12)
ylabel('R', 'FontSize',12)
grid on
