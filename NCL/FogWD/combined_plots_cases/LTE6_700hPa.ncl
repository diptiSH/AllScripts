begin

;;;;;;;; input files

fin700z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z700_download.nc","r")
fin700t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t700_download.nc","r")

;;;;;;;;; Read Variables
z700_old=fin700z->z
t700_old=fin700t->t

;;;;;;; Convert to appropriate units
z700=z700_old/9.81
t700=t700_old

copy_VarMeta(z700_old,z700)

units=z700&time@units


wks = gsn_open_wks("png","Anomaly_700hPa_LTE6")         ; send graphics to PNG file
plot=new(4,"graphic")

;;;;;;;;;;; resources for 700Z and 700T
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
 ; res@tiMainString     = "700hPa Geopotential Height (m) and Temperature(C)"          ; add title
    
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"



   sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  sres@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
  sres@gsnContourZeroLineThicknessF = 3.5 
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  sres@cnMinLevelValF  = -100.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 100.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 5.0                     ; set the interval between contours
  sres@cnInfoLabelOn = True
  sres@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  sres@gsnRightString = ""
  
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
testz700=new((/dimsizes(data),dimsizes(z700(0,:,0)),dimsizes(z700(0,0,:))/),typeof(z700))
testt700=new((/dimsizes(data),dimsizes(t700(0,:,0)),dimsizes(t700(0,0,:))/),typeof(t700))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testz700(i,:,:)=z700({JTime},:,:)
	testt700(i,:,:)=t700({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_z700=dim_avg_n_Wrap(testz700,0)
comp_t700=dim_avg_n_Wrap(testt700,0)

  res@gsnLeftString = " "                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnCenterString = folder_names(c)
  
  plot1 = gsn_csm_contour_map(wks,comp_t700,res)    ; create and draw the temperature plot
  
   plot2 = gsn_csm_contour(wks,comp_z700,sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
plot(c)=plot1

delete(data)
delete(year)
delete(month)
delete(day)
delete(testz700)
delete(testt700)
delete(comp_z700)
delete(comp_t700)
delete(plot1)
delete(plot2)
end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="700hPa Geopotential Height (m) and Temperature(C)"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
  gsn_panel(wks,plot,(/2,2/),resP)          ; now draw as one plot

end


