[cost_island,Ploss_island,psub_island,ploss_island,hourly_cost_island,bb_island]=islandingmode(bb,alpha,beta,zeeta ,DG_Min_Max_Bid,Bid_Market,Intervals,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV1,Ld_Fact,Load_demand,all_production,Wind_pwr_Forecast_legitment,PV_pwr_Forecast_legitment,wtt,pvv,psub1);
bb=bb_island;
all_production_island=[ipop_PV',ipop_WT',bb_island(1:T)',bb(1*T+1:2*T)',bb_island(2*T+1:3*T)',bb_island(3*T+1:4*T)',bb_island(4*T+1:5*T)',bb_island(5*T+1:6*T)',ipop_WT2',ipop_WT3',ipop_PV2'];
%%  DG shutdown - islanding mode-dg_num --> no shutdowns=0  fc=1  mt1=2   mt2=5  mt3=6
dg_num1=6
dg_num2=0
hour=12

power_lack_ac=zeros(1,24)

bb=bb_island;
[cost_real,Ploss2,psub2,ploss2,all_production2,hourly_cost2]=scenario_maker(bb,alpha,beta,zeeta ,DG_Min_Max_Bid,Bid_Market,Intervals,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV1,Ld_Fact,Load_demand,all_production,Wind_pwr_Forecast_legitment,PV_pwr_Forecast_legitment,wtt,pvv,power_lack_ac,dg_num1,dg_num2,hour);