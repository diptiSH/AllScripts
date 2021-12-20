begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_uvrh500_download.nc","r")
fin700z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_uvrh700_download.nc","r")
fin300z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_uvrh300_download.nc","r")
fin950z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_uvrh950_download.nc","r")

;;;;;;;;;;;;;Read Variables
u500=fin500z->u
v500=fin500z->v
u700=fin700z->u
v700=fin700z->v
u300=fin300z->u
v300=fin300z->v
u950=fin950z->u
v950=fin950z->v

printVarSummary(u300)

units=u500&time@units

;;;;;;;;; read dates

;print(Dates)

data=asciiread("Dates.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


do i=0,dimsizes(data)-1

;;;;;;;;;;;;;;;;; get data on given days



        JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
        comp_u500=u500({JTime},:,:)
        comp_v500=v500({JTime},:,:)
        comp_u700=u700({JTime},:,:)
        comp_v700=v700({JTime},:,:)
        comp_u950=u950({JTime},:,:)
        comp_v950=v950({JTime},:,:)
        comp_u300=u300({JTime},:,:)
        comp_v300=v300({JTime},:,:)



wks = gsn_open_wks("png","Anomaly_winds"+year(i)+month(i)+day(i))         ; send graphics to PNG file

  vcres                         = True             ; plot mods desired
  vcres@gsnFrame                = False            ; so we can draw time stamp
  vcres@gsnDraw      =  False                   ; do not draw the plot
;  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
  vcres@vcRefLengthF            = 0.045            ; define length of vec ref
  vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  vcres@vcMinDistanceF          = 0.017
  vcres@mpMinLonF            =  0.               ; select a subregion
  vcres@mpMaxLonF            =  120.
  vcres@mpMinLatF            =   0.
  vcres@mpMaxLatF            =  60.
  vcres@vcRefMagnitudeF         = 10.0
  vcres@gsnLeftString =" "
  vcres@gsnCenterString = "500hPa wind "
  plot500=gsn_csm_vector_map(wks,comp_u500,comp_v500,vcres)

  vcres@vcRefMagnitudeF         = 10.0
  vcres@gsnCenterString = "300hPa wind "
  plot300=gsn_csm_vector_map(wks,comp_u300,comp_v300,vcres)

  vcres@vcRefMagnitudeF         = 2.0
  vcres@gsnCenterString = "700hPa wind "
  plot700=gsn_csm_vector_map(wks,comp_u700,comp_v700,vcres)

vcres@vcRefMagnitudeF         = 1.0
  vcres@gsnCenterString = "950hPa wind "
  plot950=gsn_csm_vector_map(wks,comp_u950,comp_v950,vcres)

  ;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  gsn_panel(wks,(/plot300,plot500,plot700,plot950/),(/2,2/),resP)          ; now draw as one plot


          






end do

end

