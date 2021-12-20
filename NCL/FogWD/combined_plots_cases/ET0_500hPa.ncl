begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
fin500t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t500_download.nc","r")

;;;;;;;;; Read Variables
z500_old=fin500z->z
t500_old=fin500t->t

;;;;;;; Convert to appropriate units
z500=z500_old/9.81
t500=t500_old

copy_VarMeta(z500_old,z500)

units=z500&time@units


wks = gsn_open_wks("png","Anomaly_500hPa_ET0")         ; send graphics to PNG file
plot=new(4,"graphic")

;;;;;;;;;;; resources for 500Z and 500T
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
  res@cnMinLevelValF  = -4.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 4.0                    ; set the maximum contour level
  res@cnLevelSpacingF = .5                     ; set the interval between contours

  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"



   sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  sres@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
  sres@gsnContourZeroLineThicknessF = 3.5 
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  sres@cnMinLevelValF  = -120.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 120.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 10.0                     ; set the interval between contours
  sres@cnInfoLabelOn = True
  sres@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  sres@gsnRightString = ""
  
  folder_names=(/"pre98_ET0_WD","post98_ET0_WD","pre98_ET0_NOWD","post98_ET0_NOWD"/)
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
testz500=new((/dimsizes(data),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))
testt500=new((/dimsizes(data),dimsizes(t500(0,:,0)),dimsizes(t500(0,0,:))/),typeof(t500))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testz500(i,:,:)=z500({JTime},:,:)
	testt500(i,:,:)=t500({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,0)
comp_t500=dim_avg_n_Wrap(testt500,0)

  res@gsnLeftString = " "                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnCenterString = folder_names(c)
  
  plot1 = gsn_csm_contour_map(wks,comp_t500,res)    ; create and draw the temperature plot
  
   plot2 = gsn_csm_contour(wks,comp_z500,sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
plot(c)=plot1

delete(data)
delete(year)
delete(month)
delete(day)
delete(testz500)
delete(testt500)
delete(comp_z500)
delete(comp_t500)
delete(plot1)
delete(plot2)
end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="500hPa Geopotential Height (m) and Temperature(C)"
  resP@gsnPanelLabelBar=True     ;; add common label bar 
  gsn_panel(wks,plot,(/2,2/),resP)          ; now draw as one plot

end


