begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_mslp_download.nc","r")


;;;;;;;;; Read Variables
slp_old=short2flt(fin500z->msl_0001)


;;;;;;; Convert to appropriate units
slp=slp_old/100.0


copy_VarMeta(slp_old,slp)

units=slp&time@units

W_word=(/"WD","NOWD"/)

c_word=(/"GTE12","LTE6","ET0"/)

do w=0,1

do c=0,2

;;;;;;;;; read dates
fname="/home/cccr/rameshv/dipti/NCL/FogWD/post98_"+c_word(c)+"_"+W_word(w)+"/Dates.txt"
data=asciiread(fname,-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


;;;;;;;;; Define variables to hold values before making composites
testslppost=new((/dimsizes(data),dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testslppost(i,:,:)=slp({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_slppost=dim_avg_n_Wrap(testslppost,0)

delete(data)

delete(year)
delete(month)
delete(day)
delete(testslppost)
;;;;;;;;; read dates
fname="/home/cccr/rameshv/dipti/NCL/FogWD/pre98_"+c_word(c)+"_"+W_word(w)+"/Dates.txt"
data=asciiread(fname,-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


;;;;;;;;; Define variables to hold values before making composites
testslppre=new((/dimsizes(data),dimsizes(slp(0,:,0)),dimsizes(slp(0,0,:))/),typeof(slp))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testslppre(i,:,:)=slp({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_slppre=dim_avg_n_Wrap(testslppre,0)
;;;;;;;;;;;;;; Difference
comp_slppost=comp_slppost-comp_slppre


delete(data)

delete(year)
delete(month)
delete(day)
delete(testslppre)


wks = gsn_open_wks("png","Diff_post-pre98_mslp_"+c_word(c)+"_"+W_word(w))         ; send graphics to PNG file

;;;;;;;;;;; resources for 500Z and 500T
  res = True
;  res@gsnDraw      =  False                   ; do not draw the plot
 ; res@gsnFrame     =  False                   ; do not advance the frame
    res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True      ; turn the map outline on
;  res@lbLabelBarOn= False ;;; turn off individual label bar
   res@mpGeophysicalLineColor = "black"
   ;res@mpGeophysicalLineThicknessF = 2.5
  res@cnFillOn        = True                  ; color fill
  res@cnLinesOn       = False                 ; do not draw contour lines
  res@cnFillPalette   = "BlWhRe";"BlueRed";"BlueDarkRed18"
res@cnLevelSelectionMode = "ManualLevels" ; use explicit levels
res@cnMinLevelValF  = -5.0                    ; set the minimum contour level
res@cnMaxLevelValF  = 5.0                    ; set the maximum contour level
res@cnLevelSpacingF = 1.0                    ; set the interval between contours

  res@gsnRightString = ""
  res@gsnPolar   = "NH"                    ; do not draw the right sub-title (otherwise automatically set to temp@units)
 res@tiMainString     = "MSLP (hPa) Post 98 - Pre 98 "+c_word(c)+"_"+W_word(w)          ; add title
    
  res@tiMainFontHeightF = 0.015
  res@lbOrientation="Vertical"

plot1 = gsn_csm_contour_map(wks,comp_slppost,res)


delete(wks)
delete(plot1)

end do
end do

end
