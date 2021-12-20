begin

fin950t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_t950_3_download.nc","r")
finSur=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5_.75_decJan_1979_2018_d2m_t2m_3_download.nc","r")

t950=short2flt(fin950t->t)
t2m=short2flt(finSur->t2m)
d2m=short2flt(finSur->d2m)

printVarSummary(t950)


inv=t2m
inv=t2m-t950

dd=t2m
dd=t2m-d2m

units=t2m&time@units

;;;;;;;;; read dates

;print(Dates)

data=asciiread("/home/cccr/rameshv/dipti/NCL/Fog15Vs3/WD0_DatesGTE15.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


;;;;;;;;; Define variables to hold values before making composites
testinv=new((/dimsizes(data),dimsizes(inv(0,:,0)),dimsizes(inv(0,0,:))/),typeof(inv))
testdd=new((/dimsizes(data),dimsizes(dd(0,:,0)),dimsizes(dd(0,0,:))/),typeof(dd))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testinv(i,:,:)=inv({JTime},:,:)
	testdd(i,:,:)=dd({JTime},:,:)
	
end do	

;;;;;;;;; Average over time to get composite values
comp_inv=dim_avg_n_Wrap(testinv,0)
comp_dd=dim_avg_n_Wrap(testdd,0)


wks = gsn_open_wks("png","Inv_DD_WD0_GTE15")         ; send graphics to PNG file

;;;;;;;;;;; resources for SLP
    resSLP = True
   resSLP@gsnDraw      =  False                   ; do not draw the plot
  resSLP@gsnFrame     =  False                   ; do not advance the frame
   resSLP@mpFillOn = False
  ;resSLP@mpCenterLonF = 80
  resSLP@mpMinLonF            =  60.               ; select a subregion
  resSLP@mpMaxLonF            =  100.
  resSLP@mpMinLatF            =   10. 
  resSLP@mpMaxLatF            =  40. 
  resSLP@mpOutlineOn = True                            ; turn the map outline on
  ; resSLP@mpGeophysicalLineColor = "Grey"
   ;resSLP@mpGeophysicalLineThicknessF = 2.5
  resSLP@cnFillOn        = True                  ; color fill
  resSLP@cnLinesOn       = False                 ; do not draw contour lines
  resSLP@cnFillPalette   = "topo_15lev";"GMT_gebco";"BlWhRe";"BlueRed";"BlueDarkRed18"
  resSLP@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  resSLP@cnMinLevelValF  = 0.                   ; set the minimum contour level
  resSLP@cnMaxLevelValF  = 5.                   ; set the maximum contour level
  resSLP@cnLevelSpacingF = .5                     ; set the interval between contours
  resSLP@gsnLeftString = " "                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  resSLP@gsnRightString = ""
    ;resSLP@tiMainString     = "Mean Sea Level PresSLPsure (hPa)"          ; add title
   
  resSLP@tiMainFontHeightF = 0.015
  resSLP@lbOrientation="Vertical"
  resSLP@gsnCenterString = "Dew point depression C" 
plotdd = gsn_csm_contour_map(wks,comp_dd,resSLP)    ; create and draw the temperature plot

resSLP@cnFillPalette   = "BlWhRe";
  resSLP@cnMinLevelValF  = -5.                   ; set the minimum contour level
  resSLP@cnMaxLevelValF  = 5.                   ; set the maximum contour level
  resSLP@cnLevelSpacingF = .5                     ; set the interval between contours 
resSLP@gsnCenterString = "Invesion t2m-t950 C" 
plotInv = gsn_csm_contour_map(wks,comp_inv,resSLP)    ; create and draw the temperature plot

;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots

gsn_panel(wks,(/plotdd,plotInv/),(/2,1/),resP)          ; now draw as one plot







end
