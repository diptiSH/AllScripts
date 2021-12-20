begin


fin950tAdv=addfile("/home/cccr/rameshv/dipti/Data/eraDown/humidityAdvect950.nc","r")

advT=fin950tAdv->advq

printVarSummary(advT)


units=advT&time@units

data=asciiread("Dates_WD0_GTE15.txt",-1,"string")

print(data)
delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testadvT=new((/dimsizes(data),dimsizes(advT(0,:,0)),dimsizes(advT(0,0,:))/),typeof(advT))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testadvT(i,:,:)=advT({JTime},:,:)
end do


;;;;;;;;; Average over time to get composite values
comp_advT=dim_avg_n_Wrap(testadvT,0)
comp_advT=comp_advT*10000000.0

wks = gsn_open_wks("png","Qadvection_950_WD0_GTE15")         ; send graphics to PNG file


;;;;;;;;;;; resources for 500Z and 500T
  res = True
 ; res@gsnDraw      =  False                   ; do not draw the plot
;  res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpMinLonF            =  0.               ; select a subregion
  res@mpMaxLonF            =  120.
  res@mpMinLatF            =   0. 
  res@mpMaxLatF            =  60. 
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "Black"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
 res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -1.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 1.0                    ; set the maximum contour level
 res@cnLevelSpacingF = 0.1                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
 
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "950hPa Specific Humidity Advection *10**5	K/s"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,comp_advT,res)    ; create and draw the temperature plot









end