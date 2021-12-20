begin


;;;;;;;; input files
zfile=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5_.75_decJan_2019_z500_download.nc","r")
tfile=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5_.75_decJan_2019_t500_download.nc","r")

z=zfile->z_0005(:,{500},:,:)

z=z/9.81
printVarSummary(z)

t=tfile->t_0005(:,{500},:,:)



;printVarSummary(t)
units=z&time@units
print(units)


;print(z)

;JTime=cd_inv_calendar(2019,12,16,0,00,00,units,0)



;print(JTime)
;print(z({JTime},:,:))

;exit

year=2019
month=12

do d=16,31

  wks = gsn_open_wks("png","Anomaly500Z_T"+year+"dec"+d) 

;;;;;;;;;;; resources for 500Z and 500T
  res = True
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "white"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@lbLabelBarOn = False
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
 res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
 res@cnMinLevelValF  = -16.0                    ; set the minimum contour level
res@cnMaxLevelValF  = 16.0                    ; set the maximum contour level
res@cnLevelSpacingF = 2.0                     ; set the interval between contours
  res@gsnLeftString = year+"dec"+d                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
;  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
 ;  res@gsnCenterString = "500hPa Geopotential Height (m) and Temperature(C)"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"

sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  sres@gsnContourNegLineDashPattern = 1       ; sets negative contours to dash pattern 1
  sres@gsnContourZeroLineThicknessF = 2.5
  sres@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  sres@cnMinLevelValF  = -400.0                    ; set the minimum contour level
  sres@cnMaxLevelValF  = 400.0                   ; set the maximum contour level
  sres@cnLevelSpacingF = 40.0                     ; set the interval between contours
  sres@cnInfoLabelOn = True
  sres@gsnLeftString = ""                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  sres@gsnRightString = "" 
 plot=new(4,"graphic") 
 i=0
  do h=0,18,6
 JTime=cd_inv_calendar(year,month,d,h,00,00,units,0)
  print(JTime)
  res@gsnRightString = "time: "+h
;  print(t)
 ; print(t({JTime},:,:))
  plot1 = gsn_csm_contour_map(wks,t({JTime},:,:),res) 
  plot2 = gsn_csm_contour(wks,z({JTime},:,:),sres)    ; create and draw the temperature plot

overlay(plot1,plot2)
   plot(i)=plot1
   i=i+1

  ; print(h)
 end do

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resourcesgsnPanelLabelBar = True
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelLabelBar = True
 gsn_panel(wks,plot,(/2,2/),resP)          ; now draw as one plot


end do

end














