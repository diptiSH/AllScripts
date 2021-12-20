begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
fin500t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t500_download.nc","r")
fin700z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z700_download.nc","r")
fin700t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t700_download.nc","r")
fin300z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z300_download.nc","r")
fin300t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t300_download.nc","r")
fin950z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z950_download.nc","r")
fin950t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t950_download.nc","r")


;;;;;;;;; Read Variables
z500_old=fin500z->z
t500_old=fin500t->t
z700_old=fin700z->z
t700_old=fin700t->t
z300_old=fin300z->z
t300_old=fin300t->t
z950_old=fin950z->z
t950_old=fin950t->t

;;;;;;; Convert to appropriate units
z500=z500_old/9.81
t500=t500_old
z700=z700_old/9.81
t700=t700_old
z300=z300_old/9.81
t300=t300_old
z950=z950_old/9.81
t950=t950_old

copy_VarMeta(z500_old,z500)
copy_VarMeta(z950_old,z950)
copy_VarMeta(z300_old,z300)
copy_VarMeta(z700_old,z700)

units=z500&time@units


;;;;;;;;; read dates

;print(Dates)

data=asciiread("som2GTE15.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testz500=new((/dimsizes(data),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))
testt500=new((/dimsizes(data),dimsizes(t500(0,:,0)),dimsizes(t500(0,0,:))/),typeof(t500))
testz950=new((/dimsizes(data),dimsizes(z950(0,:,0)),dimsizes(z950(0,0,:))/),typeof(z950))
testt950=new((/dimsizes(data),dimsizes(t950(0,:,0)),dimsizes(t950(0,0,:))/),typeof(t950))
testz700=new((/dimsizes(data),dimsizes(z700(0,:,0)),dimsizes(z700(0,0,:))/),typeof(z700))
testt700=new((/dimsizes(data),dimsizes(t700(0,:,0)),dimsizes(t700(0,0,:))/),typeof(t700))
testz300=new((/dimsizes(data),dimsizes(z300(0,:,0)),dimsizes(z300(0,0,:))/),typeof(z300))
testt300=new((/dimsizes(data),dimsizes(t300(0,:,0)),dimsizes(t300(0,0,:))/),typeof(t300))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testz500(i,:,:)=z500({JTime},:,:)
	testt500(i,:,:)=t500({JTime},:,:)
	testz700(i,:,:)=z700({JTime},:,:)
    testt700(i,:,:)=t700({JTime},:,:)
	testz950(i,:,:)=z950({JTime},:,:)
    testt950(i,:,:)=t950({JTime},:,:)
	testz300(i,:,:)=z300({JTime},:,:)
    testt300(i,:,:)=t300({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,0)
comp_t500=dim_avg_n_Wrap(testt500,0)
comp_z950=dim_avg_n_Wrap(testz950,0)
comp_t950=dim_avg_n_Wrap(testt950,0)
comp_z300=dim_avg_n_Wrap(testz300,0)
comp_t300=dim_avg_n_Wrap(testt300,0)
comp_z700=dim_avg_n_Wrap(testz700,0)
comp_t700=dim_avg_n_Wrap(testt700,0)


wks = gsn_open_wks("png","Anomaly_LevelsZT_som2_GTE15")         ; send graphics to PNG file


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
  res@cnMinLevelValF  = -4.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 4.0                    ; set the maximum contour level
  res@cnLevelSpacingF = .5                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "500hPa Geopotential Height (m) and Temperature(C)"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,comp_t500,res)    ; create and draw the temperature plot

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
 plot2 = gsn_csm_contour(wks,comp_z500,sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
plot_500ZT=plot1

res@gsnCenterString = "700hPa Geopotential Height (m) and Temperature(C)"
res@cnMinLevelValF  = -5.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 5.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 1.  
plot1=gsn_csm_contour_map(wks,comp_t700,res) 
 sres@cnMinLevelValF  = -100.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 100.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 5.0     
plot2 = gsn_csm_contour(wks,comp_z700,sres)  
overlay(plot1,plot2)
plot_700ZT=plot1

res@gsnCenterString = "300hPa Geopotential Height (m) and Temperature(C)"
res@cnMinLevelValF  = -4.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 4.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 1.  
plot1=gsn_csm_contour_map(wks,comp_t300,res) 
 sres@cnMinLevelValF  = -180.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 180.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 20.0     
plot2 = gsn_csm_contour(wks,comp_z300,sres) 
overlay(plot1,plot2) 
plot_300ZT=plot1

res@gsnCenterString = "950hPa Geopotential Height (m) and Temperature(C)"
res@cnMinLevelValF  = -7.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 7.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 1.  
plot1=gsn_csm_contour_map(wks,comp_t950,res) 
 sres@cnMinLevelValF  = -100.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 100.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 5.0     
plot2 = gsn_csm_contour(wks,comp_z950,sres) 
overlay(plot1,plot2)
plot_950ZT=plot1




;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  gsn_panel(wks,(/plot_300ZT,plot_500ZT,plot_700ZT,plot_950ZT/),(/2,2/),resP)          ; now draw as one plot

end
