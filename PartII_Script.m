%%%%part2#
Vg=28; %input voltage
L=50*10^-6; % inductance
R=3; % resistance
C=500*10^-6; % capacitance
Fs=100*10^3; % switching frequency
Vm=4; % pulse with modulator voltage
Vref=5.29; % voltage referance
V=15;% load voltage
D=0.536;%duty cycle
phi=62.8; % desired phase margin, altered to fulfill the 59.5 requirement
Fc=5*10^3;% desired crossover freq
H=0.3526; % the gain
Vc=2.144; % control voltage

num=V/D ;
den=[L*C, L/R, 1];
Gvd=tf(num,den);% the open-loop control to output transfer function

%[Gm,Pm,Wcg,Wcp] = margin(sys)  % bode plot spec

num1=[L 0];
den1=[L*C L/R 1];
Zout=tf(num1,den1);
num2=[D];
den2=[D*L*C D*L/R D];
Gvg=tf(num2,den2);
%%%%%%%%%%%%%%%
% the uncompensated case, Gc=1
Tuo=(H*V)/(D*Vm);
Wo=1/(L*C)^(1/2);
Qo=R*((L/C)^(1/2));
num3=num * H/Vm;
den3=den;
T=tf(num3,den3); %Uncompensated Loop Gain

%%%%%%%%%%%%%%%
% lead compensater
Fo=Wo/(2*pi);
Fz=Fc*((1-sind(phi))/(1+sind(phi)))^(1/2);
Fp=Fc*((1+sind(phi))/(1-sind(phi)))^(1/2);
Gco=((Fc/Fo)^2)*(1/Tuo)*((Fz/Fp)^(1/2));
Wz=2*Fz*pi;
Wp=2*Fp*pi;
num4=[Gco/Wz, Gco];
den4=[0, 1/Wp, 1];
Gc=tf(num4,den4); %Lead Compensator transfer function
                   %bode(Gc, {1,10000000})
                    %grid on
Ts=T*Gc; %Loop Gain After adding Lead Compensator

%%%%%%%%%%%%%%%%%
% lag compensator
Gcm=1;
Fl=400; %chosen arbitrarily
Wl=2*Fl*pi;
num6=[1 Wl];
den6=[1 0];
Gclag=tf(num6,den6);

%%%%%%%%%%%%%% 
%Lead-lag compensator

Gll=Gc*Gclag;
Tss=T*Gll;
