function [cost_second,Plosss,Volt_dev]=Cost_eval(ipop,DG_Min_Max_Bid,Bid_Market,Intervals,Wind_pwr_Forecast,PV_pwr_Forecast,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV,Ld_Fact,phev_demand)

Loca=[12 25 30 18 21 16]; % Location of MT2 MT3 WT2 DC WT3 PV2

ipop_PV=PV*PV_pwr_Forecast;
ipop_PV2=PV2*PV_pwr_Forecast;

ipop_WT=WT1*Wind_pwr_Forecast;
ipop_WT2=WT2*Wind_pwr_Forecast;
ipop_WT3=WT3*Wind_pwr_Forecast;

ipop_FC=ipop(0*Intervals+1:1*Intervals);
ipop_MT=ipop(1*Intervals+1:2*Intervals);
ipop_Bat=ipop(2*Intervals+1:3*Intervals);
ipop_Market=ipop(3*Intervals+1:4*Intervals);
ipop_MT2=ipop(4*Intervals+1:5*Intervals);
ipop_MT3=ipop(5*Intervals+1:6*Intervals);


cost_PV=sum(ipop_PV.*DG_Min_Max_Bid(1,4));
cost_WT=sum(ipop_WT.*DG_Min_Max_Bid(2,4));
cost_FC=sum(ipop_FC.*DG_Min_Max_Bid(3,4));
cost_MT=sum(ipop_MT.*DG_Min_Max_Bid(4,4));
cost_Bat=sum(ipop_Bat.*DG_Min_Max_Bid(5,4));
cost_MT2=sum(ipop_MT2.*DG_Min_Max_Bid(7,4));
cost_MT3=sum(ipop_MT3.*DG_Min_Max_Bid(8,4));
cost_WT2=sum(ipop_WT2.*DG_Min_Max_Bid(2,4));
cost_WT3=sum(ipop_WT3.*DG_Min_Max_Bid(2,4));
cost_PV2=sum(ipop_PV2.*DG_Min_Max_Bid(1,4));

Bus_data(Loca(4),2)=0;
Bus_data1=Bus_data;
for i=1:Intervals
    Branch_data_new=Branch_data;
    Bus_data(:,2)=Bus_data1(:,2)+((phev_demand(i))./(max(size(Bus_data(:,2)))))/Ld_Fact(i);
    Bus_data(1,2)=0;
    Bus_data(Loca(4),2)=0;
    Bus_data;
    Bus_data_new=Bus_data;
    Bus_data_new(:,[2:3])=Ld_Fact(i)*Bus_data_new(:,[2:3]);
    Bus_data_new(Loca(1),2)=Bus_data_new(Loca(1),2)-ipop_MT2(i);
    Bus_data_new(Loca(2),2)=Bus_data_new(Loca(2),2)-ipop_MT3(i);
    Bus_data_new(Loca(3),2)=Bus_data_new(Loca(3),2)-ipop_WT2(i);
    Bus_data_new(Loca(4),2)=ipop_Market(i);
    Bus_data_new(Loca(5),2)=Bus_data_new(Loca(5),2)-ipop_WT3(i);
    Bus_data_new(Loca(6),2)=Bus_data_new(Loca(6),2)-ipop_PV2(i);

    [Ploss(i),Voltage(i,:)]=loadflowDG(Branch_data_new,Bus_data_new);
    Flag=(Ploss(i)==Ploss(i));
    if Flag==0
        Ploss(i)=1000000
        Voltage(i,:)=1;
    end
    Psub(i)=sum(Bus_data_new(:,2));
    Volt_dev(i)=max(1-min(Voltage(i,:)),max(Voltage(i,:))-1);
end
cost_Market=(Ploss+abs(Psub)).*Bid_Market;
cost_first=[cost_PV,cost_WT,cost_FC,cost_MT,cost_Bat,cost_Market,cost_MT2,cost_MT3,cost_WT2,cost_WT3,cost_PV2];
cost_second=sum(cost_first')';
Plosss=sum(Ploss);
Volt_dev;

