function ipop_edit=limiting(ipop,Intervals,DG_Min_Max_Bid,Wind_pwr_Forecast,PV_pwr_Forecast,WT1,WT2,WT3,PV2,PV,Load_demand)

Batter_Charge=zeros(1,Intervals);

% For PV
PV_Pwr_max=PV*PV_pwr_Forecast;

% For Wind
Wind_Pwr_max=WT1*Wind_pwr_Forecast;

% For FC
for i=0*Intervals+1:1*Intervals
    if i > 0*Intervals+1       %ramp_up/down
        dev_ipop_fc=ipop(1,i)-ipop(1,i-1);
        if abs(dev_ipop_fc) > DG_Min_Max_Bid(3,6)
            ipop(1,i)=ipop(1,i-1)+sign(dev_ipop_fc)*DG_Min_Max_Bid(3,6);
        end
    end
    if ipop(1,i)>DG_Min_Max_Bid(3,3)
        ipop(1,i)=DG_Min_Max_Bid(3,3);
    elseif ipop(1,i)<DG_Min_Max_Bid(3,2)
        ipop(1,i)=0;
        if i~=0*Intervals+1
            dev_ipop_fc=ipop(1,i)-ipop(1,i-1);
            if abs(dev_ipop_fc) > DG_Min_Max_Bid(3,6)
                ipop(1,i)=DG_Min_Max_Bid(3,2);
            end
        end
    end
    % end
end

% For MT
for i=1*Intervals+1:2*Intervals
    if i > 1*Intervals+1
        dev_ipop_mt=ipop(1,i)-ipop(1,i-1);
        if abs(dev_ipop_mt) > DG_Min_Max_Bid(4,6)
            ipop(1,i)=ipop(1,i-1)+sign(dev_ipop_mt)*DG_Min_Max_Bid(4,6);
        end
    end
    if ipop(1,i)>DG_Min_Max_Bid(4,3)
        ipop(1,i)=DG_Min_Max_Bid(4,3);
    elseif ipop(1,i)<DG_Min_Max_Bid(4,2)
        ipop(1,i)=0;
        if i~=1*Intervals+1
            dev_ipop_mt1=ipop(1,i)-ipop(1,i-1);
            if abs(dev_ipop_mt1) > DG_Min_Max_Bid(4,6)
                ipop(1,i)=DG_Min_Max_Bid(4,2);
            end
        end
    end
    %     end
end
% For Battery
for i=2*Intervals+1:3*Intervals
    if ipop(1,i)< DG_Min_Max_Bid(5,2)
        ipop(1,i)=DG_Min_Max_Bid(5,2);
    elseif ipop(1,i) > min(DG_Min_Max_Bid(5,3),-Batter_Charge(i-2*Intervals));
        ipop(1,i)=min(DG_Min_Max_Bid(5,3),-Batter_Charge(i-2*Intervals));
    end
    Batter_Charge(i-2*Intervals+1)=Batter_Charge(i-2*Intervals)+ipop(1,i);
    %     end
end
% For Market
for i=3*Intervals+1:4*Intervals
    if ipop(1,i)>DG_Min_Max_Bid(6,3)
        ipop(1,i)=DG_Min_Max_Bid(6,3);
    elseif ipop(1,i)<DG_Min_Max_Bid(6,2)
        ipop(1,i)=DG_Min_Max_Bid(6,2);
    end
    %     end
end
% For MT 2
for i=4*Intervals+1:5*Intervals
    if i> 4*Intervals+1
        dev_ipop_mt2=ipop(1,i)-ipop(1,i-1);
        if abs(dev_ipop_mt2) > DG_Min_Max_Bid(7,6)
            ipop(1,i)=ipop(1,i-1)+sign(dev_ipop_mt2)*DG_Min_Max_Bid(7,6);
        end
    end
    if ipop(1,i)>DG_Min_Max_Bid(7,3)
        ipop(1,i)=DG_Min_Max_Bid(7,3);
    elseif ipop(1,i)<DG_Min_Max_Bid(7,2)
        ipop(1,i)=0;
        if i~= 4*Intervals+1
            dev_ipop_mt2=ipop(1,i)-ipop(1,i-1);
            if abs(dev_ipop_mt2) > DG_Min_Max_Bid(7,6)
                ipop(1,i)=DG_Min_Max_Bid(7,2);
            end
        end
    end
end

% For MT 3
for i=5*Intervals+1:6*Intervals
    if i> 5*Intervals+1
        dev_ipop_mt3=ipop(1,i)-ipop(1,i-1);
        if abs(dev_ipop_mt3) > DG_Min_Max_Bid(8,6)
            ipop(1,i)=ipop(1,i-1)+sign(dev_ipop_mt3)*DG_Min_Max_Bid(8,6);
        end
    end
    if ipop(1,i)>DG_Min_Max_Bid(8,3)
        ipop(1,i)=DG_Min_Max_Bid(8,3);
    elseif ipop(1,i)<DG_Min_Max_Bid(8,2)
        ipop(1,i)=0;
        if i~= 5*Intervals+1
            dev_ipop_mt3=ipop(1,i)-ipop(1,i-1);
            if abs(dev_ipop_mt3) > DG_Min_Max_Bid(8,6)
                ipop(1,i)=DG_Min_Max_Bid(8,2);
            end
        end
    end
end

ipop_FC=ipop(0*Intervals+1:1*Intervals);
ipop_MT=ipop(1*Intervals+1:2*Intervals);
ipop_Bat=ipop(2*Intervals+1:3*Intervals);
ipop_Market=ipop(3*Intervals+1:4*Intervals);
ipop_PV=PV_Pwr_max;
ipop_WT=Wind_Pwr_max;

Production_new=ipop_Market+ipop_MT+ipop_FC+ipop_PV+ipop_WT+ipop_Bat;
Load_error=Load_demand-Production_new;
rand_select=randperm(4);
kkk=1;
ee=0;
while kkk~=5
    
    ipop((rand_select(kkk)-1)*Intervals+1:rand_select(kkk)*Intervals)=ipop((rand_select(kkk)-1)*Intervals+1:rand_select(kkk)*Intervals)+Load_error;
    
    for i=(rand_select(kkk)-1)*Intervals+1:rand_select(kkk)*Intervals
        if rand_select(kkk)==1 || rand_select(kkk)==2|| rand_select(kkk)==5 || rand_select(kkk)==6;
            if i>(rand_select(kkk)-1)*Intervals+1
                dev_ipop_rand=ipop(1,i)-ipop(1,i-1);
                if abs(dev_ipop_rand)>(DG_Min_Max_Bid(2+rand_select(kkk),6))
                    ipop(1,i)=ipop(1,i-1)+sign(dev_ipop_rand)*(DG_Min_Max_Bid(2+rand_select(kkk),6));
                end
            end
            if ipop(1,i)>DG_Min_Max_Bid(2+rand_select(kkk),3)
                ipop(1,i)=DG_Min_Max_Bid(2+rand_select(kkk),3);
            elseif ipop(1,i)<DG_Min_Max_Bid(2+rand_select(kkk),2)
                if rand>0.5
                    ipop(1,i)=0;
                     if i~=(rand_select(kkk)-1)*Intervals+1
                        dev_ipop=ipop(1,i)-ipop(1,i-1);
                        if abs(dev_ipop) > DG_Min_Max_Bid(2+rand_select(kkk),6)
                            ipop(1,i)=DG_Min_Max_Bid(2+rand_select(kkk),2);
                        end
                    end
                else
                    ipop(1,i)=DG_Min_Max_Bid(2+rand_select(kkk),2);
                end
            end
        elseif rand_select(kkk)==3
            
            if ipop(1,i)< DG_Min_Max_Bid(5,2)
                ipop(1,i)=DG_Min_Max_Bid(5,2);
            elseif ipop(1,i) > min(DG_Min_Max_Bid(5,3),-Batter_Charge(i-2*Intervals));
                ipop(1,i)=min(DG_Min_Max_Bid(5,3),-Batter_Charge(i-2*Intervals));
            end
            Batter_Charge(i-2*Intervals+1)=Batter_Charge(i-2*Intervals)+ipop(1,i);
            
        else
            if ipop(1,i)>DG_Min_Max_Bid(2+rand_select(kkk),3)
                ipop(1,i)=DG_Min_Max_Bid(2+rand_select(kkk),3);
            elseif ipop(1,i)<DG_Min_Max_Bid(2+rand_select(kkk),2)
                ipop(1,i)=DG_Min_Max_Bid(2+rand_select(kkk),2);
            end
        end
    end
    kkk=kkk+1;
    
    ipop_FC=ipop(0*Intervals+1:1*Intervals);
    ipop_MT=ipop(1*Intervals+1:2*Intervals);
    ipop_Bat=ipop(2*Intervals+1:3*Intervals);
    ipop_Market=ipop(3*Intervals+1:4*Intervals);
    ipop_PV=PV_Pwr_max;
    ipop_WT=Wind_Pwr_max;
    pro=[ipop_PV',ipop_WT',ipop_FC',ipop_MT',ipop_Bat',ipop_Market'];
    Production_new=ipop_Market+ipop_MT+ipop_FC+ipop_PV+ipop_WT+ipop_Bat;
    Load_error=Load_demand-Production_new;
    sum(abs(Load_error));
    if round(sum(abs(Load_error))*10^3)~=0 & kkk==5
        kkk=1;
    end
end
ipop_edit=ipop;
