begin


;;;;;;add files
fWDI=addfile("/home/cccr/rameshv/dipti/Data/eraDown/BII.nc","r")

WDI=fWDI->BII

printVarSummary(WDI)

time=fWDI->time
units=time@units

;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)


nyears=dimsizes(ispan(1998,2014,1))
ntimes=nyears*2*31

nlat=dimsizes(WDI&latitude)
nlon=dimsizes(WDI&longitude)

fog=new((ntimes),"integer")
WDIforReg=new((/nlat,nlon,ntimes/),typeof(WDI))


in=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
  
   fog(in)= sum(fogdata({:},{yr},{mn},{d}))
    WDIforReg(:,:,in)=(WDI({JTime},{:},{:}))
   

   in=in+1
  end do
 end do
end do


regVals=WDI(0,:,:)
printVarSummary(regVals)

regVals=(/regCoef(fog,WDIforReg)/)
regVals=regVals*100.00
printVarSummary(regVals)

;************************************************
; create default plot
;************************************************
  wks  = gsn_open_wks("png","RegBII_after97")                 ; open a png file
  
  res  = True

;res = True
 ; res@gsnDraw      =  False                   ; do not draw the plot
 ; res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True                            ; turn the map outline on
   res@mpGeophysicalLineColor = "white"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -1.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 1.0                    ; set the maximum contour level
  res@cnLevelSpacingF = .125                     ; set the interval between contours
  res@gsnLeftString = "a)"                      ; do not draw the left sub-title (otherwise automatically set to temp@long_name)
  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 ; res@tiMainString     = "500hPa Geopotential Height (m) and Temperature(C)"          ; add title
    res@gsnCenterString = "foggy station regressed on BII"
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"
plot1 = gsn_csm_contour_map(wks,regVals,res)    ; create and draw the temperature plot

;print(regVals)

end
