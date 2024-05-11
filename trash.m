
cost_new;
[cost_MGs1,Ploss1,Voltage,A,B,C,D,E,ploss1,psub1,hourly_cost1]=Cost_eval(X_gbest,DG_Min_Max_Bid,Bid_Market,Intervals,Wind_pwr_Forecast,PV_pwr_Forecast,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV1,Ld_Fact);
bb=X_gbest;
cost_MGs1;
Ploss1;