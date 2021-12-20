begin

;;;;;;;; input files

finmslpz=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_mslp_download.nc","r")


;;;;;;;;; Read Variables
zmslp_old=finmslpz->msl_0001


;;;;;;; Convert to appropriate units
zmslp=zmslp_old/100


copy_VarMeta(zmslp_old,zmslp)

units=zmslp&time@units


wks = gsn_open_wks("png","Anomaly_mslp_LTE6")         ; send graphics to PNG file
plot=new(4,"graphic")

;;;;;;;;;;; resources for mslpZ and mslpT
  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True      ; turn the map outline on
  res@lbLabelBarOn= False ;;; turn off individual label bar
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
 ; res@tiMainString     = "mslphPa Geopotential Height (m) and Temperature(C)"          ; add title
    
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"



  
  folder_names=(/"pre98_LTE6_WD","post98_LTE6_WD","pre98_LTE6_NOWD","post98_LTE6_NOWD"/)
  home_folder="/home/cccr/rameshv/dipti/NCL/FogWD/"

do c=0,3

;;;;;;;;; read dates

;print(Dates)

fname=home_folder+folder_names(c)+"/Dates.txt"

data=asciiread(fname,-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testzmslp=new((/dimsizes(data),dimsizes(zmslp(0,:,0)),dimsizes(zmslp(0,0,:))/),typeof(zmslp))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testzmslp(i,:,:)=zmslp({JTime},:,:)


end do

;;;;;;;;; Average over time to get composite values
comp_zmslp=dim_avg_n_Wrap(testzmslp,0)


  res@gsnLeftString = " "                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnCenterString = folder_names(c)
  
  plot1 = gsn_csm_contour_map(wks,comp_zmslp,res)    ; create and draw the temperature plot
  

plot(c)=plot1

delete(data)
delete(year)
delete(month)
delete(day)
delete(testzmslp)
delete(comp_zmslp)
delete(plot1)

end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="mslp(hPa)"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
  gsn_panel(wks,plot,(/2,2/),resP)          ; now draw as one plot

end


