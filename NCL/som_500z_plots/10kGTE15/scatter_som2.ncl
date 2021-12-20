begin

;;;;;;;;; read Data

data=asciiread("AO_som2GTE15.txt",-1,"string")

print(data)

AO=tofloat(data)

;AO=(/1,5,40,50/)

data=asciiread("EU_som2GTE15.txt",-1,"string")

print(data)

EU=tofloat(data)


;************************************************
 wks  = gsn_open_wks("png","scatter_som2GTE15")             ; send graphics to PNG file
 
 res                     = True                   ; plot mods desired
 res@gsnMaximize         = True                   ; maximize plot in frame
 res@xyMarkLineModes     = "Markers"  ; choose which have markers
 res@xyMarkers           = 16                     ; choose type of marker 
 res@xyMarkerColor       = "red"                  ; Marker color
 res@xyMarkerSizeF       = 0.005                  ; Marker size (default 0.01)
 res@xyDashPatterns      = 1                      ; solid line 
 res@xyLineThicknesses   = 1                ; set second line to 2

;---Resources for X/Y axes.
  res@trYMinF            =  -5.0               ; min value on y-axis
  res@trYMaxF            =  5.0               ; max value on y-axis
  res@trXMinF            =  -8.0                  ; min value on x-axis
  res@trXMaxF            =  8.0

;---Title resources
  res@tiMainString       = "AO Vs EU"
  res@tiXAxisString      = "AO index"
  res@tiYAxisString      = "EU index"
  res@tiMainFontHeightF  = 0.03

;---Draw x and y reference lines

  res@gsnYRefLine     = 0
  res@gsnXRefLine     = 0


 res@tiMainString        = "WD1_LTE3North"  ; title

 plot  = gsn_csm_xy (wks,AO,EU,res)        ; create plot












end
