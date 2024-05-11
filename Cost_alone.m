clc
clear
tic
format long
warning off
Iter=200;
n_p=50;
T=24;% Hour
MT_C=[.23 .19 .14 .12 .12 .13 .13 .14 0.17 .22 .22 .22 .21 .22 .19 .18 .17 .23 .21 .22 .18 .17 .13 .12];
Ld_Fact=[0.8 0.805 0.81	0.818 0.83 0.91 0.95 .97 1	0.98 1 0.97 0.95 0.9 0.905 0.91 0.93 0.9 .94 .97 1 .93 0.9 0.94];
WT_Pwr=1500*[.119 .119 .119 .119 .119 .061 .119 .087 .119 .206 .385 .394 .261 .158 .119 .087 .119 .119 .0868 .119 .0867 .0867 .061 .041];
PV_Pwr=2000*[.119 .119 .119 .119 .119 .061 .119 .087 .119 .206 .385 .394 .261 .158 .119 .087 .119 .119 .0868 .119 .0867 .0867 .061 .041];
%WT=1 PV=2 D1=3 D2=4 D3=5 D4=6
%type Min  Max  Cost   Up/Dn  Min Up/Dn
%2=D                    Rate     Time
WT_PV_D=[
    2  800	 3000    0.157	1500      3
    2  800	 2000	 0.155	1500      3
    2  500	 2500	 0.218	1000      2
    2  500	 2500	 0.194	1000      2
    1  0	 25	     1.0734	0         0
    1  0	 25	     1.0734	0         0];
%    Stoarg  Cap   Min-Max ch/Disch  Min Ch/Disch
%                     rate Power        Time
Storage=[1  2000      50    200         5];
% Adjustable Loads (S=1:Shiftable, C=2:Curtaiable)
% Type Min   Max  Required Inital-St/End  MinUp
%      Cap   Cap   Energy     Time        Time
LD=[1 0  80  320 11 14 1
    1 0  80  320 15 19 1
    1 20 80  240 16 19 1
    2 10 50  300 1  24 24
    2 20 60  300 13 24 12];

Branch_data=[
    1	1	2	0.0922	0.047;
    2	2	3	0.493	0.2511;
    3	3	4	0.366	0.1864;
    4	4	5	0.3811	0.1941;
    5	5	6	0.819	0.707;
    6	6	7	0.1872	0.6188;
    7	7	8	0.7114	0.2351;
    8	8	9	1.03	0.74;
    9	9	10	1.044	0.74;
    10	10	11	0.1966	0.065;
    11	11	12	0.3744	0.1238;
    12	13	14	0.5416	0.7129;
    13	12	13	1.468	1.155;
    14	14	15	0.591	0.526;
    15	15	16	0.7463	0.545;
    16	16	17	1.289	1.721;
    17	17	18	0.732	0.574;
    18	2	19	0.164	0.1565;
    19	19	20	1.5042	1.3554;
    20	20	21	0.4095	0.4784;
    21	21	22	0.7089	0.9373;
    22	3	23	0.4512	0.3083;
    23	23	24	0.898	0.7091;
    24	24	25	0.896	0.7011;
    25	6	26	0.203	0.1034;
    26	26	27	0.2842	0.1447;
    27	27	28	1.059	0.9337;
    28	28	29	0.8042	0.7006;
    29	29	30	0.5075	0.2585;
    30	30	31	0.9744	0.963;
    31	31	32	0.3105	0.3619;
    32	32	33	0.341	0.5302];

Bus_data=[
    1	0	0 ;
    2	100	60;
    3	90	40;
    4	120	80;
    5	60	30;
    6	60	20;
    7	200	100;
    8	200	100;
    9	60	20;
    10	60	20;
    11	45	30;
    12	60	35;
    13	60	35;
    14	120	80;
    15	60	10;
    16	60	20;
    17	60	20;
    18	90	40;
    19	90	40;
    20	90	40;
    21	90	40;
    22	90	40;
    23	90	50;
    24	420	200;
    25	420	200;
    26	60	25;
    27	60	25;
    28	60	20;
    29	120	70;
    30	200	600;
    31	150	70;
    32	210	100;
    33	60	40];

Data_Tie_Switch=[
    1	8	21	2	2;
    2	9	15	2	2;
    3	12	22	2	2;
    4	18	33	.5	.5;
    5	25	29	.5	 .5];
limit=[2 12 8 15 22;
    7 14 11 17 24;
    18 12 21 25 22;
    20 14 21 32 24];

Custom=[500
    400
    600
    350
    350
    1000
    1000
    550
    550
    400
    300
    400
    550
    300
    450
    300
    400
    450
    350
    450
    550
    450
    1500
    1300
    300
    500
    300
    600
    900
    800
    1050
    300];
T=24;
nD=4;
nS=1;
nLdS=3;
nLdC=2;
nTie=5;
nSw=5;
N=T*(nTie+nSw)+T*nD+T*nS++LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1+LD(4,6)-LD(4,5)+1+LD(5,6)-LD(5,5)+1;
fb=[Branch_data(:,2);Data_Tie_Switch(:,2)];
tb=[Branch_data(:,3);Data_Tie_Switch(:,3)];
tie_sw_AMP=[Branch_data;Data_Tie_Switch];
jay=sqrt(-1);
num_tie_sw=length(Branch_data)+length(Data_Tie_Switch);

for i=1:T
    Bus_data_new=Bus_data;
    Bus_data_new(:,2:3)=Ld_Fact(i)*Bus_data_new(:,2:3);
    [Ploss_init(i),Voltage_init(i,:)]=loadflowDG(Branch_data,Bus_data_new);
end

for i=1:num_tie_sw
    Current_init(fb(i),tb(i))=12.66*10^3*(Voltage_init(tie_sw_AMP(i,2))-Voltage_init(tie_sw_AMP(i,3)))/(tie_sw_AMP(i,4)+jay*tie_sw_AMP(i,5));
end
Current_init=abs(Current_init);
Amp_Branch=abs(Branch_data(:,4)+jay*Branch_data(:,5));
Amp_tie=abs(Data_Tie_Switch(:,4)+jay*Data_Tie_Switch(:,5));
Amp=[Amp_Branch;Amp_tie];
max_Amp=max(Amp);
min_Amp=min(Amp);
max_b=find(ismember(Amp,max_Amp));
min_b=find(ismember(Amp,min_Amp));
lambda_max=0.4;
lambda_min=0.1;
Repair_min=0.5;
Repair_max=6;
for i=1:1:num_tie_sw
    Lambda(fb(i),tb(i))=lambda_max+((lambda_max-lambda_min)/(max_Amp-min_Amp)*(Amp(i,:)-max_Amp));
end
Lambda=Lambda;
% [SAIFI_init,SAIDI_init,ASAI_init,AENS_init,Total_ECost_init,ECost_init,ENS_init]=Cost_Rel(fb,tb,Bus_data,Branch_data,...
%     Custom,Voltage_init,Current_init,Lambda,Repair_min,Repair_max);

%%%
[Ploss_init_WT,Voltage_init_WT]=loadflowDG(Branch_data,Bus_data);
% [Price,Price2]=Cost_func7(Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
    
    
% [SAIFI_init_WT,SAIDI_init_WT,ASAI_init_WT,AENS_init_WT,Total_ECost_init_WT,ECost_init_WT,ENS_init_WT]=Cost_Rel(fb,tb,Bus_data,Branch_data,...
%     Custom,Voltage_init_WT,Current_init,Lambda,Repair_min,Repair_max);

for i=1:n_p
    ipop(i,:)=population(limit,WT_PV_D,Storage,LD,nTie,nD,nS,nLdS,nLdC,T);
    ipop(i,:)=limit_fun(ipop(i,:),nTie,nSw,limit,T,nD,nS,nLdC,nLdS,LD,WT_PV_D,Storage);
    [Price,Price_DG2,Ploss,Voltage,SAIFIt,SAIDIt,AENSt]=Cost_func6(ipop(i,:),Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,...
        Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
    cost(i,:)=Price;
end
ipop_cost=[ipop,cost];

for kk=1:Iter  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%Iteration
    for i=1:n_p
        ipop_sort=sortrows(ipop_cost,N+1);
        teacher=ipop_sort(1,:);
        X_teacher=teacher(1,1:N);
        cost_teacher=teacher(1,N+1);
        m_D=mean(ipop_cost(:,1:N));
        M_new=X_teacher;
        differ=rand*(M_new-round(1+rand)*m_D);
        ipop_new(i,:)=ipop(i,:)+differ;
        ipop_new(i,:)=limit_fun(ipop_new(i,:),nTie,nSw,limit,T,nD,nS,nLdC,nLdS,LD,WT_PV_D,Storage);
        [Price,Price_DG2,Ploss,Voltage,SAIFIt,SAIDIt,AENSt]=Cost_func6(ipop_new(i,:),Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,...
        Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
        cost_new(i,:)=Price;
        if cost_new(i,:)<cost(i,:)
            ipop(i,:)=ipop_new(i,:);
            cost(i,:)=cost_new(i,:);
            ipop_cost(i,:)=[ipop(i,:),cost(i,:)];
        end
        r_p=randperm(n_p);
        if ipop_cost(r_p(1,1),N+1)< ipop_cost(r_p(1,2),N+1)
            ipop_new(r_p(1,1),:)=ipop(r_p(1,1),:)+rand*(ipop(r_p(1,1),:)-ipop(r_p(1,2),:));
        else
            ipop_new(r_p(1,1),:)=ipop(r_p(1,1),:)+rand*(ipop(r_p(1,2),:)-ipop(r_p(1,1),:));
        end
        
        ipop_new(r_p(1,1),:)=limit_fun(ipop_new(r_p(1,1),:),nTie,nSw,limit,T,nD,nS,nLdC,nLdS,LD,WT_PV_D,Storage);
        [Price,Price_DG2,Ploss,Voltage,SAIFIt,SAIDIt,AENSt]=Cost_func6(ipop_new(r_p(1,1),:),Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,...
        Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
        cost_new(r_p(1,1),:)=Price;
        if cost_new(r_p(1,1),1)< cost(r_p(1,1),1)
            ipop(r_p(1,1),:)=ipop_new(r_p(1,1),:);
            cost(r_p(1,1),:)=cost_new(r_p(1,1),:);
            ipop_cost(r_p(1,1),:)=[ipop(r_p(1,1),:), cost(r_p(1,1),:)];
        end
        r_p=randperm(n_p);
        nn1=r_p(1,1);
        nn2=r_p(1,2);
        nn3=r_p(1,3);
        if nn1~=nn2~=nn3~=i
            X_mut=ipop(nn1,:)+(.1+rand*.8)*(ipop(nn2,:)-ipop(nn3,:));
            X_mut=limit_fun(X_mut,nTie,nSw,limit,T,nD,nS,nLdC,nLdS,LD,WT_PV_D,Storage);
            Cr1=(.1+rand*.8);
            Cr2=(.1+rand*.8);
            Cr3=(.1+rand*.8);
            for j=1:N
                if Cr1>rand
                    XX(1,j)=X_teacher(1,j);
                else
                    XX(1,j)=ipop(i,j);
                end
                
                if Cr2>rand
                    XX(2,j)=X_mut(1,j);
                else
                    XX(2,j)=ipop(i,j);
                end
                
                if Cr3>rand
                    XX(3,j)=X_mut(1,j);
                else
                    XX(3,j)=X_teacher(1,j);
                end
            end
            for ii=1:3
                XX(ii,:)=limit_fun(XX(ii,:),nTie,nSw,limit,T,nD,nS,nLdC,nLdS,LD,WT_PV_D,Storage);
                [Price,Price_DG2,Ploss,Voltage,SAIFIt,SAIDIt,AENSt]=Cost_func6(XX(ii,:),Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,...
                 Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
                cost_XX(ii,:)=Price;
            end
            XX_ipop_cost=[XX,cost_XX];
            sort_XX=sortrows([XX_ipop_cost;ipop_cost(i,:)],N+1);
            ipop_cost(i,:)=sort_XX(1,:);
            ipop(i,1:N)=ipop_cost(i,1:N);
            cost(i,:)=ipop_cost(i,N+1);
        end
    end
    clc
    kk
    mem(kk,:)=cost_teacher
    X_teacher;
    %     save
end


[Price,Price_DG2,Ploss,Voltage,SAIFIt,SAIDIt,AENSt]=Cost_func8(X_teacher,Bus_data,Branch_data,Data_Tie_Switch,MT_C,LD,...
 Custom,Current_init,Lambda,Repair_min,Repair_max,fb,tb,Ld_Fact,WT_Pwr,PV_Pwr,nD,nS,WT_PV_D);
format short
X1=X_teacher(1:2*nTie*T)
for k=1:nD
    X2(k,:)=X_teacher(2*nTie*T+(k-1)*T+1:2*nTie*T+T*k);
end
X2
X3=X_teacher(2*nTie*T+T*nD+1:2*nTie*T+T*nD+T*nS)
X4=X_teacher(2*nTie*T+T*nD+T*nS+1:2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1)
X5=X_teacher(2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+1:2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1)
X6=X_teacher(2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+1:2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1)
X7=X_teacher(2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1+1:2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1+LD(4,6)-LD(4,5)+1)
X8=X_teacher(2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1+LD(4,6)-LD(4,5)+1+1:2*nTie*T+T*nD+T*nS+LD(1,6)-LD(1,5)+1+LD(2,6)-LD(2,5)+1+LD(3,6)-LD(3,5)+1+LD(4,6)-LD(4,5)+1+LD(5,6)-LD(5,5)+1)

