begin


;;;;;;;;;;slp file
fslp=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
;;;; read variables
slp_old=short2flt(fslp->z(:,:,:))
;;;;;;; Convert to appropriate units
slp=slp_old/9.81


copy_VarMeta(slp_old,slp)

units=slp&time@units

pString=(/"NE","PO","pos1","neg1","0_neg1","0_pos1","cntAll"/)

do ps=0,dimsizes(pString)-1


;;;;read Dates
folder="/home/cccr/rameshv/dipti/NCL/FogWD_July2020/GetDates_stddev_30-40_65-75/"
fname="Dates_ETO_"+pString(ps)+".txt"

Dates=asciiread(folder+fname,-1,"string")
;print(Dates)

days=toint(str_get_field(Dates,3,"-"))
years=toint(str_get_field(Dates,1,"-"))
months=toint(str_get_field(Dates,2,"-"))

;print(years)

ndays=dimsizes(Dates)
print(ndays)

;;;;;;;;define var
slp_var=new((/ndays,dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))


do i=0,ndays-1
 JTime=cd_inv_calendar(years(i),months(i),days(i),9,00,00,units,0)
 slp_var(i,:,:)=slp({JTime},:,:)
end do



;;;;;;;;; Average over time to get composite values
comp_slp=dim_avg_n_Wrap(slp_var,0)

;;;;;;;;;plotting

wks = gsn_open_wks("png","500hPaAnom_ET0_Polar"+pString(ps))

;;;;;;;resources

  res = True
;  res@gsnDraw      =  False                   ; do not draw the plot
;  res@gsnFrame     =  False                   ; do not advance the frame
  res@gsnPolar = "NH" 
  res@mpFillOn = False
  res@cnFillOn        = False                  ; color fill
  res@cnLinesOn       = True                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
  res@mpOutlineOn = True      ; turn the map outline on
  res@gsnContourNegLineDashPattern = 11
  res@gsnContourPosLineDashPattern = 0
  res@gsnContourZeroLineThicknessF=2
 ; res@lbLabelBarOn= False ;;; turn off individual label bar
  res@mpGeophysicalLineColor = "black"
  res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
  res@cnMinLevelValF  = -50.0                    ; set the minimum contour level
  res@cnMaxLevelValF  = 50.0                    ; set the maximum contour level
  res@cnLevelSpacingF = 5.0                     ; set the interval between contours.0
  res@gsnAddCyclic=False
  res@gsnRightString = "ET0"
  res@mpCenterLonF     = 80.                   ; center plot at 180
;  res@mpMinLonF        = 30.                   ; select a subregion
;  res@mpMaxLonF        = 120.
;  res@mpMinLatF        = 0.
;  res@mpMaxLatF        =  70.
  res@gsnLeftString = pString(ps)
  res@gsnCenterString = ndays
 

  plot = gsn_csm_contour_map_polar(wks,comp_slp,res) 
  

delete(Dates)
delete(days)
delete(months)
delete(years)
delete(comp_slp)
delete(plot)
delete(wks)
delete(slp_var)

end do


end
