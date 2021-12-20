	begin

;;;;;;;; input files
fin2mT=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t2m_download.nc","r")
finSLP=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_mslp_download.nc","r")
finu10v10=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_u10v10_download.nc","r")



;;;;;;;;; Read Variables

t2m_old=fin2mT->t2m_0001
u10=finu10v10->u10_0001
v10=finu10v10->v10_0001
slp_old=finSLP->msl_0001


;;;;;;; Convert to appropriate units

t2m=t2m_old
slp=slp_old/100.0

copy_VarMeta(slp_old,slp)




units=t2m&time@units


;;;;;;;;; read tes

;print(Dates)

data=asciiread("Dates.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	
	testu10=u10({JTime},:,:)
	testv10=v10({JTime},:,:)
         testt2m=t2m({JTime},:,:)
	 testslp=slp({JTime},:,:)


wks = gsn_open_wks("png","SLP_SUR_"+year(i)+month(i)+day(i))         ; send graphics to PNG file




;;;;;;;;;;; resources for SLP
resSLP = True
   resSLP@gsnDraw      =  False                   ; do not draw the plot
  resSLP@gsnFrame     =  False                   ; do not advance the frame
   resSLP@mpFillOn = False
  resSLP@mpCenterLonF = 80
  resSLP@mpOutlineOn = True                            ; turn the map outline on
   resSLP@mpGeophysicalLineColor = "black"
   ;resSLP@mpGeophysicalLineThicknessF = 2.5
  resSLP@cnFillOn        = True                  ; color fill
  resSLP@cnLinesOn       = False                 ; do not draw contour lines
  resSLP@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  resSLP@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  resSLP@cnMinLevelValF  = -5.                   ; set the minimum contour level
  resSLP@cnMaxLevelValF  = 5.                   ; set the maximum contour level
 resSLP@cnLevelSpacingF = .5                    ; set the interval between contours
  resSLP@gsnLeftString = "b)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  resSLP@gsnRightString = ""
  resSLP@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
  ;resSLP@tiMainString     = "Mean Sea Level PresSLPsure (hPa)"          ; add title
   resSLP@gsnCenterString = "Mean Sea Level PresSLPsure (hPa)" 
  resSLP@tiMainFontHeightF = 0.015
  resSLP@lbOrientation="Vertical"
plotSLP = gsn_csm_contour_map(wks,testslp,resSLP)    ; create and draw the temperature plot





;;;;;;;;;;;;;;;;; Resources for 2m temp and wind 10m 
gsn_define_colormap(wks,"BlWhRe")             ; choose colormap
  reswind10T2m = True
  reswind10T2m@gsnDraw      =  False                   ; do not draw the plot
  reswind10T2m@gsnFrame     =  False                   ; do not advance the frame
  reswind10T2m@mpFillOn = False
  reswind10T2m@mpCenterLonF = 80
  reswind10T2m@mpOutlineOn = True                            ; turn the map outline on
   reswind10T2m@cnFillOn        = True                  ; color fill
  reswind10T2m@cnLinesOn       = False                 ; do not draw contour lines
   reswind10T2m@mpGeophysicalLineColor = "black"
 ; reswind10T2m@cnFillPalette        = colors
  reswind10T2m@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  reswind10T2m@cnMinLevelValF  = -4.0                  ; set the minimum contour level
  reswind10T2m@cnMaxLevelValF  =4.0                 ; set the maximum contour level
  reswind10T2m@cnLevelSpacingF = 0.5                    ; set the interval between contours
  reswind10T2m@gsnLeftString = "d)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  reswind10T2m@gsnRightString = ""
  reswind10T2m@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
   reswind10T2m@stArrowLengthF     = 0.005               ; default is dynamic
  ;reswind10T2m@stLengthCheckCount = 5                    ; default is 35
  reswind10T2m@stArrowStride      = 1
  reswind10T2m@stLineStartStride  = 1                    ; default is 2
  reswind10T2m@stMinArrowSpacingF = 0.03                 ; default is 0.0             
  reswind10T2m@stStepSizeF        = 0.001                ; default is dynamic
  ; reswind10T2m@stLineColor = "gray30"
  reswind10T2m@stMinDistanceF     = 0.03                 ; distance between lines
  reswind10T2m@stMinLineSpacingF  = 0.005                
  reswind10T2m@gsnSpreadColors     = True                ; use full colormap
 ; reswind10T2m@gsnSpreadColorStart = 2 
  ;reswind10T2m@gsnSpreadColorEnd   = -3 
  reswind10T2m@lbOrientation="Vertical"
  ;reswind10T2m@tiMainString     = "2m Tempeature (C) Surface Winds (m/s)"          ; add title
   reswind10T2m@gsnCenterString = "2m Tempeature (C) Surface Winds (m/s)"  
  reswind10T2m@tiMainFontHeightF = 0.015
plotwind10T2m = gsn_csm_streamline_contour_map_polar(wks,testu10,testv10,testt2m,reswind10T2m)    ; create and draw the temperature plot



;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
;  gsn_panel(wks,(/plot_500ZT,plotSLP,plotWind500,plotwind10T2m/),(/2,2/),resP)          ; now draw as one plot
; gsn_panel(wks,(/plot_500ZT,plotSLP/),(/2,1/),resP)          ; now draw as one plot
gsn_panel(wks,(/plotSLP,plotwind10T2m/),(/2,1/),resP)          ; now draw as one plot




end do








end
