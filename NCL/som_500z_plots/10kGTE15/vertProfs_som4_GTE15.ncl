begin

;lwcFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles","r")
uvrtFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles/ERA_allLevs_Temp_rh_1997_2018.nc","r")

t=uvrtFile->t(:,:,{20:35},{65:95})
q=uvrtFile->q(:,:,{20:35},{65:95})
v=uvrtFile->v(:,:,{20:35},{65:95})
u=uvrtFile->u(:,:,{20:35},{65:95})

q=q*100.0

windspeed=wind_speed(u,v)


levs=u&level
print(levs)
;exit

units=t&time@units

data=asciiread("som4GTE15.txt",-1,"string")

print(data)
delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testT=new((/dimsizes(data),dimsizes(t(0,:,0,0)),dimsizes(t(0,0,:,0)),dimsizes(t(0,0,0,:))/),typeof(t))
testU=new((/dimsizes(data),dimsizes(t(0,:,0,0)),dimsizes(t(0,0,:,0)),dimsizes(t(0,0,0,:))/),typeof(t))
testV=new((/dimsizes(data),dimsizes(t(0,:,0,0)),dimsizes(t(0,0,:,0)),dimsizes(t(0,0,0,:))/),typeof(t))
testQ=new((/dimsizes(data),dimsizes(t(0,:,0,0)),dimsizes(t(0,0,:,0)),dimsizes(t(0,0,0,:))/),typeof(t))
testWind=new((/dimsizes(data),dimsizes(t(0,:,0,0)),dimsizes(t(0,0,:,0)),dimsizes(t(0,0,0,:))/),typeof(t))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),3,00,00,units,0)
	testT(i,:,:,:)=t({JTime},:,:,:)
        testU(i,:,:,:)=u({JTime},:,:,:)
        testV(i,:,:,:)=v({JTime},:,:,:)
        testQ(i,:,:,:)=q({JTime},:,:,:)
        testWind(i,:,:,:)=windspeed({JTime},:,:,:)

        
end do

levs=(/1459,1328,1206,1092,987,889,798,714,637,566,500,440,385,334,287,244,205,169,136,106,79,53,30,10/)
;;;;;;;;; Average over time to get composite values
comp_T=dim_avg_n_Wrap(testT,0)
comp_U=dim_avg_n_Wrap(testU,0)
comp_V=dim_avg_n_Wrap(testV,0)
comp_Q=dim_avg_n_Wrap(testQ,0)
comp_Wind=dim_avg_n_Wrap(testWind,0)

;;;;;;;;;;;;;; plotting
 wks   = gsn_open_wks ("png","som4_GTE15_tquvwind_profiles")                  ; send graphics to PNG file
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
res@trXMinF=280.0
res@trXMaxF =290.0

 plotData=(/comp_T(:,{31.38},{74.5}),comp_T(:,{28.34},{77.1}),comp_T(:,{25.27},{82.5}),comp_T(:,{25.18},{83})/)
 plot(0)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
print(min(plotData))
print(max(plotData))

res@tiMainString      = "Specific humidity"
res@gsnCenterString="*10^-2 kg/kg"
res@trXMinF=0.0
res@trXMaxF =.9

plotData=(/comp_Q(:,{31.38},{74.5}),comp_Q(:,{28.34},{77.1}),comp_Q(:,{25.27},{82.5}),comp_Q(:,{25.18},{83})/)
 plot(1)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
print(min(plotData))
print(max(plotData))

res@tiMainString      = "U component of wind"
res@gsnCenterString="m/s"
res@trXMinF=-6.0
res@trXMaxF =6.0

plotData=(/comp_U(:,{31.38},{74.5}),comp_U(:,{28.34},{77.1}),comp_U(:,{25.27},{82.5}),comp_U(:,{25.18},{83})/)
 plot(2)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
print(min(plotData))
print(max(plotData))

res@tiMainString      = "V component of wind"
res@gsnCenterString="m/s"
res@trXMinF=-5.0
res@trXMaxF =5.0


plotData=(/comp_V(:,{31.38},{74.5}),comp_V(:,{28.34},{77.1}),comp_V(:,{25.27},{82.5}),comp_V(:,{25.18},{83})/)
 plot(3)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot
print(min(plotData))
print(max(plotData))

res@tiMainString      = "Wind Speed"
res@gsnCenterString="m/s"
res@trXMinF=0.0
res@trXMaxF =9.0

plotData=(/comp_Wind(:,{31.38},{74.5}),comp_Wind(:,{28.34},{77.1}),comp_Wind(:,{25.27},{82.5}),comp_Wind(:,{25.18},{83})/)
 plot(4)  = gsn_csm_xy (wks,plotData,levs,res) ; create plot

print(min(plotData))
print(max(plotData))

  pres                        = True
  pres@gsnMaximize            = True

  pres@gsnPanelMainString     = "WD1 LTE3"
  gsn_panel(wks,plot,(/2,3/),pres)



end
