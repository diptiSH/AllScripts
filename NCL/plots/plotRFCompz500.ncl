begin
lats=0
latn=90
lonf=0
lonr=180
ftlevelCo=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_500hPa_pl_DecJan_1979-2019_0_Down.nc","r")
ftlevel=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/AnomER5_500hPa_pl_DecJan_1979-2019_0_Down.nc","r")


z=ftlevelCo->z(:,{lats:latn},{lonf:lonr})
tsurf=ftlevel->z(:,{lats:latn},{lonf:lonr})
units=tsurf&time@units
;labels=toint(asciiread("/home/cccr/rameshv/dipti/pySom/biClustering/cluster_rflabelst2m.txt",-1,"float"))

;print(labels)

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_1.5ddCriteriaRF50Per.txt",-1,"string")
delim=","
dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))

dd=new((/dimsizes(data),dimsizes(tsurf(0,:,0)),dimsizes(tsurf(0,0,:))/),typeof(tsurf))
ddCo=new((/dimsizes(data),dimsizes(tsurf(0,:,0)),dimsizes(tsurf(0,0,:))/),typeof(tsurf))
printVarSummary(dd)
k=0
do j=0,dimsizes(data)-1
Time=cd_inv_calendar(year(j),months(j),days(j),0,0,0,units,0)
ddCo(k,:,:)=z({Time},:,:)
dd(k,:,:)=tsurf({Time},:,:)
k=k+1

end do
ddCoavg=dim_avg_n_Wrap(ddCo,0)
ddavg=dim_avg_n_Wrap(dd,0)
printVarSummary(ddavg)
wks = gsn_open_wks("png" ,"z500RFceComp")      ; send graphics to PNG file

  res                       = True     ; plot mods desired
  res@gsnDraw      =  False                   ; do not draw the plot
  res@gsnFrame     =  False                   ; do not advance the frame
  res@gsnMaximize           = True     ; Make plot fit the frame
  res@cnFillOn              = True     ; turn on color fill
  res@cnLinesOn             = False    ; turn of contour lines
  res@cnLevelSpacingF       = 0.5      ; contour spacing
  res@cnFillPalette         = "BlRe"
  res@lbOrientation         = "Vertical"

  res@gsnAddCyclic          = False    ; data already has cyclic point
				       ; this must also be set for any zoom

;
; Note that the gsn_csm_*map* templates automatically set 
; res@mpLimitMode="LatLon" for you. If you are plotting a 
; different projection, you may have to set this resource.
;
  res@mpMinLatF            = lats      ; range to zoom in on
  res@mpMaxLatF            =  latn
  res@mpMinLonF            =  lonf
  res@mpMaxLonF            = lonr
  
  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = -400.			; set the minimum contour level
  res@cnMaxLevelValF  = 400.			; set the maximum contour level
  res@cnLevelSpacingF = 50.			; set the interval between contours
  res@tiMainString = "Default map tickmark labels"
  plot = gsn_csm_contour_map(wks,ddavg, res)
  
  sres                      = True              ; set up a second resource list
  sres@gsnDraw              = False             ; do not draw the plot
  sres@gsnFrame             = False             ; do not advance the frame
  plot_ov = gsn_csm_contour(wks,ddCoavg,sres)
overlay(plot,plot_ov)
draw(plot)
frame(wks)
;delete(plot)
;delete(dd)
;end do


end
