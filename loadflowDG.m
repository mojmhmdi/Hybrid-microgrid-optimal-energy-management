function [P_loss,Bus_Voltage,Angle_Voltage,Psub,Qsub]=loadflowDG(Branch_data1,Bus_data)
V_Substation=1;
V_base=12.66;
S_Base=1000;
Z_Base=V_base^2/S_Base;
Branch_data1(:,4)=Branch_data1(:,4)/Z_Base;
Branch_data1(:,5)=Branch_data1(:,5)/Z_Base;
Branch_data=sortrows(Branch_data1,3);
Data_Tie_Switch=[1	8	21	2	2;
2	9	15	2	2;
3	12	22	2	2;
4	18	33	.5	 .5;
5	25	29	.5	 .5];
Data_Tie_Switch(:,4)=Data_Tie_Switch(:,4)/Z_Base;
Data_Tie_Switch(:,5)=Data_Tie_Switch(:,5)/Z_Base;
           
Bus_data(:,2)=Bus_data(:,2)/(1000*S_Base);
Bus_data(:,3)=Bus_data(:,3)/(1000*S_Base);
jay=sqrt(-1);
Number_of_Bus=max(Bus_data(:,1));
No_of_bus=Number_of_Bus;
Number_of_Branch=max(Branch_data(:,1));
Y_Bus=zeros(Number_of_Bus,Number_of_Bus);
for I_Ybus=1:Number_of_Branch
        Y_Bus(Branch_data(I_Ybus,2),Branch_data(I_Ybus,3))=Y_Bus(Branch_data(I_Ybus,2),Branch_data(I_Ybus,3))-1/(Branch_data(I_Ybus,4)+jay*Branch_data(I_Ybus,5));
        Y_Bus(Branch_data(I_Ybus,3),Branch_data(I_Ybus,2))=Y_Bus(Branch_data(I_Ybus,2),Branch_data(I_Ybus,3));
end
for I_Ybus=1:Number_of_Bus
    Y_Bus(I_Ybus,I_Ybus)=-sum(Y_Bus(I_Ybus,:));
end
Y_Bus_Ac=Y_Bus([2:Number_of_Bus],[2:Number_of_Bus]);
Y_Bus_Ac(1,1)=Y_Bus_Ac(1,1);%+1/(Branch_data(1,4)+jay*Branch_data(1,5));
Z_Bus=inv(Y_Bus_Ac);

DLF=Z_Bus;
Initial_Voltage=ones(No_of_bus-1,1)*V_Substation;
DLF_Itre_Max=12;
DLF_Itre =1;
Vector_Substation=V_Substation*ones(No_of_bus-1,1);
Voltage_1=Initial_Voltage;
Error=2;
while Error > 1e-14
    Load_Vector=1*(Bus_data([2:No_of_bus],2)+jay*Bus_data([2:No_of_bus],3));
    Current_Injection=conj(Load_Vector./Initial_Voltage);
    Delta_Voltage=(DLF*Current_Injection);
    Initial_Voltage=Vector_Substation-Delta_Voltage;
    Error=sqrt(sum((abs(Voltage_1-Initial_Voltage)).^2));
    Voltage_1=Initial_Voltage;
    DLF_Itre=DLF_Itre+1;
    if DLF_Itre >25
        break
    end
end
Angle_Ybus=angle(Y_Bus);
Ampliude_Ybus=abs(Y_Bus);
Bus_Voltage=abs([V_Substation;Initial_Voltage]);
Angle_Voltage=angle([V_Substation;Initial_Voltage]);
Min_Voltage=min(Bus_Voltage)/V_Substation;
Max_Voltage=max(Bus_Voltage)/V_Substation;
Psub=0;
Qsub=0;
for I_Sub=1:Number_of_Bus
    Psub=Psub+Bus_Voltage(1)*Bus_Voltage(I_Sub)*Ampliude_Ybus(1,I_Sub)*cos(Angle_Voltage(1)-Angle_Voltage(I_Sub)-Angle_Ybus(1,I_Sub));
    Qsub=Qsub+Bus_Voltage(1)*Bus_Voltage(I_Sub)*Ampliude_Ybus(1,I_Sub)*sin(Angle_Voltage(1)-Angle_Voltage(I_Sub)-Angle_Ybus(1,I_Sub));
end
Substaion=3*V_Substation*conj((V_Substation-Initial_Voltage(1))/(Branch_data(1,4)+jay*Branch_data(1,5)));
(V_Substation-Initial_Voltage(1))/(Branch_data(1,4)+jay*Branch_data(1,5));
Active_Load=sum(Bus_data([1:No_of_bus],2));
Psubb=Psub;
Ploss=(Psubb-Active_Load);
if DLF_Itre >25
    Ploss=10000000;
    Psubb=100000000;
end
P_loss=Ploss*(1000*S_Base);   % goning from P.U to real value
Bus_Voltage;
end