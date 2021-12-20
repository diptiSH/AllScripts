begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_novdecjanfeb_1979_2018_mslp_download.nc","r")

;;;;;;;;; Read Variables
z500_old=fin500z->msl_0001

;;;;;;; Convert to appropriate units
z500=z500_old/100.0

copy_VarMeta(z500_old,z500)

units=z500&time@units

print(units)

printVarSummary(z500)

;;;;;;;;; read dates

;print(Dates)

data=asciiread("Dates_WD0_GTE15.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testz500=new((/15,dimsizes(data),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))   ;;;15 for -7to +7 days

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	
	do k=-7,7
	JTimeAct=JTime+k*24
	;print(k)
	testz500(k+7,i,:,:)=z500({JTimeAct},:,:)
	
	end do
	
	
end do

;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,1)

printVarSummary(comp_z500)

wks = gsn_open_wks("png","Sequence_Anomaly_mslp_WD0_GTE15")         ; send graphics to PNG file

plot=new(15,"graphic")


;;;;;;;;;;; resources for 500Z and 500T
  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "black"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -5.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 5.0                    ; set the maximum contour level
  res@cnLevelSpacingF = .5                     ; set the interval between contours
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "MSLP Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "MSLP "
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
  res@lbLabelBarOn = False
  
  do k=-7,7
  
  res@gsnLeftString = "day "+k                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)+
  
  
plot(k+7) = gsn_csm_contour_map(wks,comp_z500(k+7,:,:),res)    ; create and draw the temperature plot
 end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelLabelBar = True
  gsn_panel(wks,plot,(/5,3/),resP)          ; now draw as one plot



end
