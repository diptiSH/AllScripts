begin

year=2019

f=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/monthly/Anomera5_500z_monthly_dec_jan_1979_2019.nc","r")

z=f->z

z=z/9.81

printVarSummary(z)

units=z&time@units

JTimedec=cd_inv_calendar(year-1,12,1,00,00,00,units,0)
    ;   print(JTime)
JTimejan=cd_inv_calendar(year,1,1,00,00,00,units,0)


zdec=z({JTimedec},:,:)
zjan=z({JTimejan},:,:)

z_avg=zdec
z_avg=(zdec+zjan)/2.0

wks = gsn_open_wks("png","Anomaly500Z"+year)     ; send graphics to PNG file

;;;;;;;;;;; resources for 500Z and 500T
  res = True
;  res@gsnDraw      =  False                   ; do not draw the plot
;  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "white"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -80.0                    ; set the minimum contour level
 res@cnMaxLevelValF  = 80.0                    ; set the maximum contour level
 res@cnLevelSpacingF = 20                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "500hPa Geopotential Height (m) and Temperature(C)"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,z_avg,res)    ; create and draw the temperature plot


end
