
for i=1:24;

ld=Ld_Fact(i)*((sum(Bus_data(:,2))-Bus_data(18,2)))+Load_demand(i)+ploss_grid_connected(i)+(31*phev_demand(i)/33);

tolid=sum(all_production_grid_connected(i,:))-all_production_grid_connected(i,6)+psub_grid_connected(i);

abas(i)=tolid-ld;
end

abas

for i=1:24;

ld=Ld_Fact(i)*(sum(Bus_data(:,2))-Bus_data(18,2))+Load_demand(i)+ploss_island(i)+(31*phev_demand(i)/33);

tolid=sum(all_production_island(i,:))-all_production_island(i,6);

abas_island(i)=tolid-ld;
end

abas_island
