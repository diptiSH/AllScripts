begin
lats=0
latn=40
lonl=60
lonr=100

fin=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/AnomER5_dd_DecJan_1979-2019_0_Down.nc","r")

dd=fin->t2m
units=dd&time@units

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetNoFogDays/NoWSFogDays_2.5ddCriteria50PerOnly_0.csv",-1,"string")
delim=","
Dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(Dates, 1, delim))
month=toint(str_get_field(Dates, 2, delim))
day=toint(str_get_field(Dates, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testdd=new((/dimsizes(Dates),dimsizes(dd(0,:,0)),dimsizes(dd(0,0,:))/),typeof(dd))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(Dates)-1

        JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
        testdd(i,:,:)=dd({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_dd=dim_avg_n_Wrap(testdd,0)
wks = gsn_open_wks("png","Anomalyddnofog_0_130")         ; send graphics to PNG file


;;;;;;;;;;; resources for 500Z and 500T
  res = True
; res@gsnDraw      =  False                   ; do not draw the plot
; res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  ;res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "white"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
res@mpMinLonF=lonl
res@mpMaxLonF=lonr
res@mpMinLatF=lats
res@mpMaxLatF=latn
 res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
 res@cnMinLevelValF  = -3.0                    ; set the minimum contour level
 res@cnMaxLevelValF  = 3.0                    ; set the maximum contour level
 res@cnLevelSpacingF = .2                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
;  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "500hPa Geopotential Height (m) and Temperature(C)"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,comp_dd,res)    ; create and draw the temperature plot


end
