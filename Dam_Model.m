%Variation of the flow through and power output of a proposed dam on River Mitano (Uganda):
%Dam is modelled for a full year using imported inflow and outflow data for
%the river in the year 2020. An average of the rate measured per second is
%used to calculate the daily rates.
load("flow_in.mat");
%Arrays storing the volume and power are created
volume=zeros(1,365);
power=zeros(1,365);
height=zeros(1,365);
flow_out=zeros(1,365);
%Volume of dam reservoir and height of stored water at full capacity
full_vol=1.5333333e7;
height(1)=50;
%Estimated lenght of body of water stored in dam reservoir following
%earlier calculations
length=5750;
%Max flow of water through the turbine
max_flow=6.1;
%Penstock area calculation
area_ps=max_flow/sqrt(2*9.81*height(1));
%Estimated efficiency of the turbine
turbine_eff=0.9;
%Initial day 1 calculation
vol_out=max_flow*24*60*60;
vol_in=flow_in(1)*24*60*60;
flow_out(1)=max_flow;
%on day 1, since the in-flow rate of 21 > out-flow of 6, we can ignore the volume change.
volume(1)=full_vol;
power(1)=max_flow*1000*9.81*height(1)*turbine_eff;
%Calculation of the power output for the rest of the year:
for i=[2:1:365]
    %Uses the volume from the previous day
    vol_in=flow_in(i)*24*60*60;
    vol_out=max_flow*24*60*60;
    volume(i)=volume(i-1)+vol_in-vol_out;
    %If the daily volume after considering the inflow and outflows
    %for the day is greater than the volume at max capacity then excess water
    %is allowed out and the dam remains at max capacity. This also means
    %the maximum amount if power is generated.
    if volume(i)> full_vol
        height(i)=50;
        volume(i)=full_vol;
        flow_out(i)=max_flow;
        power(i)=max_flow*1000*9.81*height(1)*turbine_eff;
    %If the volume for the day is less than the volume at max capacity then
    %the height of the water stored in the dam is used instead of the max
    %height so less power is generated.
    elseif volume(i)<full_vol
        %The new height is calculated using a simple model of the shape of
        %the reservoir.
        height(i)=((volume(i)*3)/368)^(1/3);
        vary_flow=area_ps*sqrt(2*9.81*height(i));
        flow_out(i)=vary_flow;
        power(i)=vary_flow*1000*9.81*height(i)*turbine_eff;
    end
end

%Plot of daily flow of water through the river and the turbine
figure()
title("Daily net flow rate of water in Lake Mitano and through the turbine: (m^3/s)",...
 "flow rates in seconds used as average for whole day)")
grid on
xlabel("Day")
ylabel("Flow rate of water (m^3/s)")
hold on
plot(1:365,flow_in,'LineWidth',1)
plot(1:365,flow_out)
xlim([1,365])
legend("River flow","Flow through turbine","Location", "Best")

%Plot of daily flow through the turbine and power output of the dam
figure()
title("Daily power output (MW) and water flow rate (m3/s) through turbine:",...
     "(flow rates in seconds used as average for whole day)")
grid on
xlabel("Day")
hold on
plot(1:365, power/(10^6),'LineWidth',1)
ylabel("Power output (MW)")
plot(1:365, flow_out,'LineWidth',1)
yyaxis right
ylabel("Flow rate of water through turbine (m^3/s)")
set(gca,'ycolor','k')
ylim([2,6.5])
xlim([1,365])
legend("Power output","Flow rate","Location", "Best")

%The plots say daily because as stated before the flow rates were
%originally in seconds but have been converted and used as the average for
%the whole day in calculations