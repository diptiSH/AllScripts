begin

;lwcFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles/","r")
uvrtFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles/ERA_allLevs_Temp_rh_1997_2018.nc","r")

t=uvrtFile->t(:,:,{20:35},{65:95})
q=uvrtFile->q(:,:,{20:35},{65:95})
v=uvrtFile->v(:,:,{20:35},{65:95})
u=uvrtFile->u(:,:,{20:35},{65:95})

q=q*100.0

windspeed=wind_speed(u,v)


levs=u&level
print(levs)

units=t&time@units


data=asciiread("Dates.txt",-1,"string")

print(data)
delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


print(data)
delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

minT=new(dimsizes(data),"float")
maxT=new(dimsizes(data),"float")
minU=new(dimsizes(data),"float")
maxU=new(dimsizes(data),"float")
minV=new(dimsizes(data),"float")
maxV=new(dimsizes(data),"float")
minQ=new(dimsizes(data),"float")
maxQ=new(dimsizes(data),"float")
minWind=new(dimsizes(data),"float")
maxWind=new(dimsizes(data),"float")


levs=(/1459,1328,1206,1092,987,889,798,714,637,566,500,440,385,334,287,244,205,169,136,106,79,53,30,10/)

do i=0,dimsizes(data)-1

JTime=cd_inv_calendar(year(i),month(i),day(i),3,00,00,units,0)
comp_T=t({JTime},:,:,:)
comp_U=u({JTime},:,:,:)
comp_V=v({JTime},:,:,:)
comp_Q=q({JTime},:,:,:)
comp_Wind=windspeed({JTime},:,:,:)


;;;;;;;;;;;;;; plotting
 wks   = gsn_open_wks ("png","tquvwind_profiles_"+year(i)+"-"+month(i)+"-"+day(i))                  ; send graphics to PNG file
 plot=new(5,"graphic")

 res                   = True                       ; plot mods desired
; res@tiMainString      = "Profile Plot"             ; add title
 res@tiYAxisString="Altitude (m)"
 res@gsnDraw   = False
 res@gsnFrame  = False
 res@xyLineColors      = (/"blue","red","black","Green"/)          ; change line color
; res@trYReverse        = True                       ; reverse Y-axis
; res@xyDashPatterns    = 15                         ; choose dash patterns
res@tiMainString      = "Temperature" 
res@gsnCenterString="K"
res@trXMinF=272.0
res@trXMaxF =297.0

 plotData=(/comp_T(:,{31.38},{74.5}),comp_T(:,{28.34},{77.1}),comp_T(:,{25.27},{82.5}),comp_T(:,{25.18},{83})/)
minT(i)=min(plotData)
maxT(i)=max(plotData)

 plot(0)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
res@tiMainString      = "Specific humidity"
res@gsnCenterString="*10^-2 kg/kg"
res@trXMinF=0.
res@trXMaxF =1.2

plotData=(/comp_Q(:,{31.38},{74.5}),comp_Q(:,{28.34},{77.1}),comp_Q(:,{25.27},{82.5}),comp_Q(:,{25.18},{83})/)
minQ(i)=min(plotData)
maxQ(i)=max(plotData)
 plot(1)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
res@tiMainString      = "U component of wind"
res@gsnCenterString="m/s"
res@trXMinF=-18.0
res@trXMaxF =18.0

plotData=(/comp_U(:,{31.38},{74.5}),comp_U(:,{28.34},{77.1}),comp_U(:,{25.27},{82.5}),comp_U(:,{25.18},{83})/)
minU(i)=min(plotData)
maxU(i)=max(plotData)
 plot(2)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot

res@tiMainString      = "V component of wind"
res@gsnCenterString="m/s"
res@trXMinF=-16.0
res@trXMaxF =16.0


plotData=(/comp_V(:,{31.38},{74.5}),comp_V(:,{28.34},{77.1}),comp_V(:,{25.27},{82.5}),comp_V(:,{25.18},{83})/)
minV(i)=min(plotData)
maxV(i)=max(plotData)
 plot(3)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot

res@tiMainString      = "Wind Speed"
res@gsnCenterString="m/s"
res@trXMinF=0
res@trXMaxF =22

plotData=(/comp_Wind(:,{31.38},{74.5}),comp_Wind(:,{28.34},{77.1}),comp_Wind(:,{25.27},{82.5}),comp_Wind(:,{25.18},{83})/)
minWind(i)=min(plotData)
maxWind(i)=max(plotData)
 plot(4)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot


  pres                        = True
  pres@gsnMaximize            = True

  pres@gsnPanelMainString     = year(i)+"-"+month(i)+"-"+day(i)
  gsn_panel(wks,plot,(/2,3/),pres)

delete(wks)
delete(plot)
end do

print(min(minT))
print(max(maxT))
print(min(minQ))
print(max(maxQ))
print(min(minU))
print(max(maxU))
print(min(minV))
print(max(maxV))
print(min(minWind))
print(max(maxWind)) 

end

