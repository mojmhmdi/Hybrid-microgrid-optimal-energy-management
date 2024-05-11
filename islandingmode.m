function [ cost_neww,Ploss,psub1,ploss,hourly_cost ,bb_island,voltage_island] = scenario_maker(bb,alpha,beta,zeeta ,DG_Min_Max_Bid,Bid_Market,Intervals,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV1,Ld_Fact,Load_demand,all_production,Wind_pwr_Forecast,PV_pwr_Forecast,Wind_pwr_Forecast_fake,PV_pwr_Forecast_fake,power_lack_ac,phev_demand)
kk=0
while kk==0
T=Intervals;

% %% generation real dc initial
% bb_wt1= WT1*Wind_pwr_Forecast;
% bb_pv=PV1*PV_pwr_Forecast;
% bb_fc_i=bb(0*Intervals+1:1*Intervals);
% bb_mt1_i=bb(1*Intervals+1:2*Intervals);
% bb_batt_i=bb(2*Intervals+1:3*Intervals);
% bb_market_i=bb(3*Intervals+1:4*Intervals);
% power_lack_ac_i=power_lack_ac;
% bb_mt2_i=bb(4*Intervals+1:5*Intervals);
% bb_mt3_i=bb(5*Intervals+1:6*Intervals);
% 
% all_production_dc_real_initial=[bb_pv',bb_wt1',bb(0*Intervals+1:1*Intervals)',bb(1*Intervals+1:2*Intervals)',bb(2*Intervals+1:3*Intervals)',bb(3*Intervals+1:4*Intervals)'];
% for e=1:24
%     gen(e)=sum(all_production_dc_real_initial(e,:));
% end
% power_lack=(gen-Load_demand)
% 
% PV=PV1;
% WT_asli=WT1*Wind_pwr_Forecast;
% WT_fake=WT1*Wind_pwr_Forecast_fake;
% WT_dev=WT_fake-WT_asli;
% PV_asli=PV*PV_pwr_Forecast;
% PV_fake=PV*PV_pwr_Forecast_fake;
% 
% m=0;
% 

%% copmensation ac

bb_mark_old= bb(73:96);
m=0;
for i=1:T
        power_lack_ac
        j=i+4*Intervals;
    m=m+1

        bb_mt2=bb(97:120)
        bb_mt2_old=bb(j)
        if j==4*Intervals+1
            bb(j)=bb(j)+power_lack_ac(m);
            if bb(j)>DG_Min_Max_Bid(7,3)
                bb(j)=DG_Min_Max_Bid(7,3);
            elseif bb(j)<DG_Min_Max_Bid(7,2)
                bb(1,j)=0
            end

        else
            bb(j)=bb(j)+power_lack_ac(m);
            dev_mt2=bb(j-1)-bb(j)
            if abs(dev_mt2)>DG_Min_Max_Bid(7,6)
                bb(j)=bb(j-1)-sign(dev_mt2)*DG_Min_Max_Bid(7,6);
            end
            if bb(j)>DG_Min_Max_Bid(7,3)
                bb(j)=DG_Min_Max_Bid(7,3);
            elseif bb(j)<DG_Min_Max_Bid(7,2)
                bb(1,j)=0;
                if j~= 4*Intervals+1
                    dev_bb_mt2=bb(1,j)-bb(1,j-1);
                    if abs(dev_bb_mt2) > DG_Min_Max_Bid(7,6)
                        bb(1,j)=DG_Min_Max_Bid(7,2);
                    end
                end
            end
        end
        mt2_compensation=bb(j)-bb_mt2_old
        power_lack_ac(m)=power_lack_ac(m)-mt2_compensation
        bb_mt2=bb(97:120)

        power_lack_ac
        %% compensation mt3
        power_lack_ac
        j=i+5*Intervals;
        bb_mt3=bb(121:144)
        bb_mt3_old=bb(j)
        if j==5*Intervals+1
            bb(j)=bb(j)+power_lack_ac(m);
            if bb(j)>DG_Min_Max_Bid(8,3)
                bb(j)=DG_Min_Max_Bid(8,3);
            elseif bb(j)<DG_Min_Max_Bid(8,2)
                bb(1,j)=0
            end
        else
            bb(j)=bb(j)+power_lack_ac(m);
            dev_mt3=bb(j-1)-bb(j)
            if abs(dev_mt3)>DG_Min_Max_Bid(8,6)
                bb(j)=bb(j-1)-sign(dev_mt3)*DG_Min_Max_Bid(8,6);
            end
            if bb(j)>DG_Min_Max_Bid(8,3)
                bb(j)=DG_Min_Max_Bid(8,3);
            elseif bb(j)<DG_Min_Max_Bid(8,2)
                bb(1,j)=0;
                if j~= 5*Intervals+1
                    dev_bb_mt3=bb(1,j)-bb(1,j-1);
                    if abs(dev_bb_mt3) > DG_Min_Max_Bid(8,6)
                        bb(1,j)=DG_Min_Max_Bid(8,2);
                    end
                end
            end
        end
        mt3_compensation=bb(j)-bb_mt3_old
        power_lack_ac(m)=power_lack_ac(m)-mt3_compensation
        bb_mt3=bb(121:144)

    %% compensation dc for ac


    %% compensation fc
    bb_fc=bb(1:24)
    power_lackk_fc=power_lack_ac;
    bb_fc_old=bb(i)
    bb_mark= bb(73:96)
    if power_lack_ac(m)>0
        cap_market=abs(DG_Min_Max_Bid(6,2)-bb(1,i+3*Intervals))
    else
        cap_market=abs(DG_Min_Max_Bid(6,3)-bb(1,i+3*Intervals))
    end

    if i==0*Intervals+1
        if power_lack_ac(m)>0
            bb(i)=bb(i)+min(power_lack_ac(m),(cap_market));
        else
            bb(i)=bb(i)-min(abs(power_lack_ac(m)),(cap_market));
        end

        if bb(i)>DG_Min_Max_Bid(3,3)
            bb(i)=DG_Min_Max_Bid(3,3);
        elseif bb(i)<DG_Min_Max_Bid(3,2)
            bb(i)=0;
        end
        fprintf('i=1')
    else
        fprintf('i>1')
        if power_lack_ac(m)>0
            bb(i)=bb(i)+min(power_lack_ac(m),(cap_market));
        else
            bb(i)=bb(i)-min(abs(power_lack_ac(m)),(cap_market));
        end
        dev_fc=bb(i-1)-bb(i);
        if abs(dev_fc)>DG_Min_Max_Bid(3,6)
            bb(i)=bb(i-1)-sign(dev_fc)*DG_Min_Max_Bid(3,6);
        end

        if bb(i)>DG_Min_Max_Bid(3,3)
            bb(i)=DG_Min_Max_Bid(3,3);
        elseif bb(i)<DG_Min_Max_Bid(3,2)
            bb(1,i)=0;
            if i~=0*Intervals+1
                dev_ipop_fc=bb(1,i)-bb(1,i-1);
                if abs(dev_ipop_fc) > DG_Min_Max_Bid(3,6)
                    bb(1,i)=DG_Min_Max_Bid(3,2);
                end
            end
        end
    end
    fc_compensation=bb(i)-bb_fc_old
    bb(1,i+3*Intervals)=bb(1,i+3*Intervals)-fc_compensation;
    bb_mark= bb(73:96)
    bb_fc=bb(1,[1:24])
    power_lack_ac(m)=power_lack_ac(m)-fc_compensation
%     %  power lack
%     all_production_dc_real=[bb_pv',bb_wt1',bb(0*Intervals+1:1*Intervals)',bb(1*Intervals+1:2*Intervals)',bb(2*Intervals+1:3*Intervals)',bb(3*Intervals+1:4*Intervals)'];
%     for e=1:24
%         gen(e)=sum(all_production_dc_real(e,:));
%     end
%     power_lack=gen-Load_demand
% 
%     bb_mark_comp=-bb_mark+bb_mark_old
    %% compensation mt1
    bb_mt1=bb(25:48)
    j=i+1*Intervals;
    bb_mt1_old=bb(j)
    power_lack_ac=power_lack_ac
    if power_lack_ac(m)>0
        cap_market=abs(DG_Min_Max_Bid(6,2)-bb(1,i+3*Intervals))
    else
        cap_market=abs(DG_Min_Max_Bid(6,3)-bb(1,i+3*Intervals))
    end
    if j==1+1*Intervals
        if power_lack_ac(m)>0
            bb(j)=bb(j)+min(power_lack_ac(m),(cap_market));
        else
            bb(j)=bb(j)-min(abs(power_lack_ac(m)),(cap_market));
        end
        if bb(j)>DG_Min_Max_Bid(4,3)
            bb(j)=DG_Min_Max_Bid(4,3);
        elseif bb(j)<DG_Min_Max_Bid(4,2)
            bb(j)=0;
        end
    else
        if power_lack_ac(m)>0
            bb(j)=bb(j)+min(power_lack_ac(m),(cap_market));
        else
            bb(j)=bb(j)-min(abs(power_lack_ac(m)),(cap_market));
        end
        dev_mt1=bb(j-1)-bb(j);
        if abs(dev_mt1)>DG_Min_Max_Bid(4,6)
            bb(j)=bb(j-1)-sign(dev_mt1)*DG_Min_Max_Bid(4,6);
        end
        if bb(j)>DG_Min_Max_Bid(4,3)
            bb(j)=DG_Min_Max_Bid(4,3);
        elseif bb(j)<DG_Min_Max_Bid(4,2)
            bb(1,j)=0;
            if j~=1*Intervals+1
                dev_ipop_mt1=bb(1,j)-bb(1,j-1);
                if abs(dev_ipop_mt1) > DG_Min_Max_Bid(4,6)
                    bb(1,j)=DG_Min_Max_Bid(4,2);
                end
            end

        end
    end
    mt1_compensation=bb(j)-bb_mt1_old
    bb_mt1=bb(25:48)
    bb_mark_comp=-bb_mark+bb_mark_old
    bb(1,i+3*Intervals)=bb(1,i+3*Intervals)-mt1_compensation;
    bb_mark= bb(73:96)
    power_lack_ac(m)=power_lack_ac(m)-mt1_compensation
%     %%  power lack
%     all_production_dc_real=[bb_pv',bb_wt1',bb(0*Intervals+1:1*Intervals)',bb(1*Intervals+1:2*Intervals)',bb(2*Intervals+1:3*Intervals)',bb(3*Intervals+1:4*Intervals)'];
%     for e=1:24
%         gen(e)=sum(all_production_dc_real(e,:));
%     end
%     power_lack=gen-Load_demand
% 

    %% compensation battery
    bb_batte= bb(49:72)
    j=i+2*Intervals;
    power_lackk_ac=power_lack_ac
    bb_batt_old=bb(j)
    if power_lack_ac(m)>0
        cap_market=abs(DG_Min_Max_Bid(6,2)-bb(1,i+3*Intervals))
    else
        cap_market=abs(DG_Min_Max_Bid(6,3)-bb(1,i+3*Intervals))
    end
    if j==2*Intervals+1
        Batter_Charge=0
    else Batter_Charge=sum(bb(2*Intervals+1:j-1))
    end

    if power_lack_ac(m)>0
        bb(j)=bb(j)+min(power_lack_ac(m),(cap_market));
    else
        bb(j)=bb(j)-min(abs(power_lack_ac(m)),(cap_market));
    end
    if bb(j)<DG_Min_Max_Bid(5,2)
        bb(j)=DG_Min_Max_Bid(5,2);
    elseif bb(j)>min(DG_Min_Max_Bid(5,3),-Batter_Charge)
        bb(j)=min(DG_Min_Max_Bid(5,3),-Batter_Charge);
        fprintf('zad bala')
    end

    batt_compensation=bb(j)-bb_batt_old
    bb_batte= bb(49:72)
    bb(1,i+3*Intervals)=bb(1,i+3*Intervals)-batt_compensation;
    bb_mark= bb(73:96)
    power_lack_ac(m)=power_lack_ac(m)-batt_compensation

%     %%  power lack
%     all_production_dc_real=[bb_pv',bb_wt1',bb(0*Intervals+1:1*Intervals)',bb(1*Intervals+1:2*Intervals)',bb(2*Intervals+1:3*Intervals)',bb(3*Intervals+1:4*Intervals)'];
%     for e=1:24
%         gen(e)=sum(all_production_dc_real(e,:));
%     end
%     power_lack=gen-Load_demand
%     bb_mark_comp=-bb_mark+bb_mark_old
end


%% cost eval
[cost_MGs,Ploss,Voltage,A,B,C,D,E,ploss,psub1,hourly_cost]=Cost_eval_islanded(bb,DG_Min_Max_Bid,Bid_Market,Intervals,Wind_pwr_Forecast_fake,PV_pwr_Forecast_fake,Branch_data,Bus_data,WT1,WT2,WT3,PV2,PV1,Ld_Fact,phev_demand);
cost_neww=cost_MGs;
% psub1=psub1+load_error_initial
ploss;
voltage_island=Voltage
Ploss;
voltage_dev=max(Voltage);
% bar(Voltage);
sum(psub1)
if abs(sum(psub1))<0.000000001
    kk=1;
end

power_lack_ac=psub1;
psub1=psub1
clc
end
bb_island=bb;