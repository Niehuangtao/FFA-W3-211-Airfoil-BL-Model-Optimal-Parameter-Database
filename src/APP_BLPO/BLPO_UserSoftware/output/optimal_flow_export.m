clc;
clear all;
warning off;
%% ==================== 1. 参数设置 ============================
%     A1     b1      A2      b2      A5      b5      Tp      Tf     Tvl
%     Tv0    yita    S1      S2      S3      S4      k0      k1     k2      k3
lb_lag = [
      0       %S1
      0       %S2
      0       %S3
      0       %S4
     ]; 

ub_lag = [
      40       %S1
      40       %S2
      40       %S3
      40       %S4
     ];    

Npara_lag = length(lb_lag); 

S1 = 2;S2 = 5;
S3 = 2;S4 = 5;

para_init_lag = [S1,S2,S3,S4];

lb_cl = [
      0       %A1
      0       %b1
      0       %A2
      0       %b2
      0       %Tp
      0       %Tf0
      0       %Tvl
      0       %Tv0
      0.85    %yita
     ]; 

ub_cl = [
      0.8     %A1
      0.8     %b1
      0.8     %A2
      0.8     %b2
      10      %Tp
      5       %Tf0
      15      %Tvl
      5      %Tv0
      0.95    %yita
     ];    

Npara_cl = length(lb_cl); 

A1   = 0.3         ; A2   = 0.3        ;
b1   = 0.3        ; b2   = 0.3           ;
Tp   = 5           ; Tf0  = 1             ;
Tvl  = 8            ; Tv0  = 2             ;
st   = 0.19          ; yita = 0.95          ;

para_init_cl = [A1,b1,A2,b2,...
            Tp,Tf0,Tvl,Tv0,...
            yita];

lb_cm = [
      0       %A3
      0       %b3
      0       %A4
      0       %b4
      0       %A5
      0       %b5
      0       %k0
      0       %k1
      0       %k2
      0       %k3
      0       %XCP
     ]; 

ub_cm = [
      0.5     %A3
      0.5     %b3
      0.5     %A4
      0.5     %b4
      0.5     %A5
      0.5     %b5
      0.5     %k0
      0.5     %k1
      0.5     %k2
      0.5     %k3
      0.5     %XCP
     ];    

Npara_cm = length(lb_cm); 

A3   = 0.2           ; b3   = 0.2           ;
A4   = 0.1           ; b4   = 0.1           ;
A5   = 0.1           ; b5   = 0.3           ;
k0   = 1             ; k1   = 1             ; 
k2   = 1             ; k3   = 1             ;
xcp = 0.2;

para_init_cm = [A3,b4,A4,b4,...
            A5,b5,k0,k1,...
            k2,k3,xcp];

para_init = [para_init_lag para_init_cl para_init_cm];
%%
%% ==================== 2. 工况设置 ============================
meanangle    = 20;
averageangle = 10;
CFDdatapath = 'FFA_W3_211_rlt_20.txt';

conditions   = input_condition(meanangle,averageangle);
airfoildata  = input_afdata;
setcase.meanangle    = meanangle;
setcase.averageangle = averageangle;
setcase.conditions   = conditions;
setcase.airfoldata   = airfoildata;
setcase.CFDdatapath  = CFDdatapath;
%%
%% ==================== 3. 优化设置 ============================
para_local_lag = run_optimal_1lag(para_init_lag,para_init_cl,para_init_cm,Npara_lag,lb_lag,ub_lag,setcase);

para_init_1 = [para_local_lag para_init_cl para_init_cm];

compare_optimal_result_lag(para_init_lag, para_init_cl, para_init_cm, para_local_lag, setcase);

%%
para_local_cl = run_optimal_2cl(para_local_lag,para_init_cl,para_init_cm,Npara_cl,lb_cl,ub_cl,setcase);

para_init_2 = [para_local_lag para_local_cl para_init_cm];

compare_optimal_result_cl(para_local_lag, para_init_cl, para_init_cm, para_local_cl,setcase);
%%
para_local_cm = run_optimal_3cm(para_local_lag,para_local_cl,para_init_cm,Npara_cm,lb_cm,ub_cm,setcase);

para_init_3 = [para_local_lag para_local_cl para_local_cm];

compare_optimal_result_cm(para_local_lag, para_local_cl, para_init_cm, para_local_cm, setcase);