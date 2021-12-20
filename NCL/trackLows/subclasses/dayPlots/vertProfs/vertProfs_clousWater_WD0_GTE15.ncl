begin

lwcFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles/ERA_allLevs_specificCloudLiquidWater_1997_2016.nc","r")
;uvrtFile=addfile("/home/cccr/rameshv/dipti/Data/ERA5_modelLevel/mergedFiles/ERA_allLevs_Temp_rh_1997_2018.nc","r")

lwc=lwcFile->clwc
lwc=lwc*1000000.0

levs=lwc&level
levs=(/987,566,205,106,10/)
print(levs)
;exit

units=lwc&time@units

data=asciiread("/home/cccr/rameshv/dipti/NCL/trackLows/subclasses/dayPlots/Dates_WD0_GTE15.txt",-1,"string")

print(data)
delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testLWC=new((/dimsizes(data),dimsizes(lwc(0,:,0,0)),dimsizes(lwc(0,0,:,0)),dimsizes(lwc(0,0,0,:))/),typeof(lwc))



;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),3,00,00,units,0)
	testLWC(i,:,:,:)=lwc({JTime},:,:,:)
        
end do


;;;;;;;;; Average over time to get composite values
comp_LWC=dim_avg_n_Wrap(testLWC,0)


;;;;;;;;;;;;;; plotting
 wks   = gsn_open_wks ("png","WD0_GTE15_clwc_profiles")                  ; send graphics to PNG file
 
 res                   = True                       ; plot mods desired
 res@tiMainString      = "WD0 GTE15"             ; add title
 res@gsnCenterString=" Specific cloud liquid water content kg/kg *10^-6"
 res@trXMinF=-10.0
  res@trXMaxF=250.0

res@tiYAxisString="Altitude (m)"
; res@gsnDraw   = False
; res@gsnFrame  = False
 res@xyLineColors      = (/"blue","red","black","Green"/)          ; change line color
; res@trYReverse        = True                       ; reverse Y-axis
 res@xyDashPatterns    = 15                         ; choose dash patterns
 plotData=(/comp_LWC(:,{31.38},{74.5}),comp_LWC(:,{28.34},{77.1}),comp_LWC(:,{25.27},{82.5}),comp_LWC(:,{25.18},{83})/)
 plot  = gsn_csm_xy (wks,plotData,levs,res) ; create plot

end
