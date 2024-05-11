function [ wtt,pvv ] = wt_pv_fd(Intervals, alpha,beta,zeeta,Wind_pwr_Forecast ,PV_pwr_Forecast)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

Wind_pwr_Forecast(1,[alpha:beta])=zeeta+Wind_pwr_Forecast(1,[alpha:beta]);


PV_pwr_Forecast(1,[alpha:beta])=zeeta+PV_pwr_Forecast(1,[alpha:beta]);


for i=1:Intervals
    if Wind_pwr_Forecast(i)>1
        Wind_pwr_Forecast(i)=1;
    elseif Wind_pwr_Forecast<0
        Wind_pwr_Forecast(i)=0;
    end
    if PV_pwr_Forecast(i)>1
        PV_pwr_Forecast(i)=1;
    elseif PV_pwr_Forecast(i)<0
        PV_pwr_Forecast_fake(i)=0;
    end
pvv=PV_pwr_Forecast;
wtt=Wind_pwr_Forecast;
end