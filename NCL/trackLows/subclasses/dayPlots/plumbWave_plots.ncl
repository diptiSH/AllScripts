begin


Fxin=addfile("/home/cccr/rameshv/dipti/NCL/waveActivity/Plumb1985-Fx.daily.NovFeb2005.nc","r")
Fyin=addfile("/home/cccr/rameshv/dipti/NCL/waveActivity/Plumb1985-Fy.daily.NovFeb2005.nc","r")

Fx=Fxin->Fx(:,{300},:,:)
Fy=Fyin->Fy(:,{300},:,:)

time=Fx&time

ntime=dimsizes(time)


do i=0,30

t=cd_calendar(time(i),2)

 wks= gsn_open_wks("png","WAFVector"+t)         ; send graphics to PNG file

  vcres                         = True             ; plot mods desired
  ;vcres@gsnFrame                = False            ; so we can draw time stamp
  ;vcres@gsnDraw      =  False                   ; do not draw the plot
;  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
  vcres@vcRefLengthF            = 0.045            ; define length of vec ref
  vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  vcres@vcMinDistanceF          = 0.017
  vcres@mpMinLonF            =  0.               ; select a subregion
 vcres@mpCenterLonF=100.0
  vcres@mpMaxLonF            =  360.
  vcres@mpMinLatF            =   0.
  vcres@mpMaxLatF            =  90.
  vcres@vcRefMagnitudeF         = 50.0
  vcres@gsnLeftString =" "
  vcres@gsnCenterString = "300hPa WAF "
  plot500=gsn_csm_vector_map(wks,Fx(i,:,:),Fy(i,:,:),vcres)




end do



















end
