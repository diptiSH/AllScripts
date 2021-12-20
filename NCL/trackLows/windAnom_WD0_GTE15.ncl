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

data=asciiread("/home/cccr/rameshv/dipti/NCL/trackLows/WD0_DatesGTE15.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testu500=new((/dimsizes(data),dimsizes(u500(0,:,0)),dimsizes(u500(0,0,:))/),typeof(u500))
testv500=new((/dimsizes(data),dimsizes(v500(0,:,0)),dimsizes(v500(0,0,:))/),typeof(v500))
testu950=new((/dimsizes(data),dimsizes(u950(0,:,0)),dimsizes(u950(0,0,:))/),typeof(u950))
testv950=new((/dimsizes(data),dimsizes(v950(0,:,0)),dimsizes(v950(0,0,:))/),typeof(v950))
testu700=new((/dimsizes(data),dimsizes(u700(0,:,0)),dimsizes(u700(0,0,:))/),typeof(u700))
testv700=new((/dimsizes(data),dimsizes(v700(0,:,0)),dimsizes(v700(0,0,:))/),typeof(v700))
testu300=new((/dimsizes(data),dimsizes(u300(0,:,0)),dimsizes(u300(0,0,:))/),typeof(u300))
testv300=new((/dimsizes(data),dimsizes(v300(0,:,0)),dimsizes(v300(0,0,:))/),typeof(v300))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testu500(i,:,:)=u500({JTime},:,:)
	testv500(i,:,:)=v500({JTime},:,:)
	testu700(i,:,:)=u700({JTime},:,:)
        testv700(i,:,:)=v700({JTime},:,:)
	testu950(i,:,:)=u950({JTime},:,:)
        testv950(i,:,:)=v950({JTime},:,:)
	testu300(i,:,:)=u300({JTime},:,:)
        testv300(i,:,:)=v300({JTime},:,:)

end do

;;;;;;;;; Average over time to get composite values
comp_u500=dim_avg_n_Wrap(testu500,0)
comp_v500=dim_avg_n_Wrap(testv500,0)
comp_u950=dim_avg_n_Wrap(testu950,0)
comp_v950=dim_avg_n_Wrap(testv950,0)
comp_u300=dim_avg_n_Wrap(testu300,0)
comp_v300=dim_avg_n_Wrap(testv300,0)
comp_u700=dim_avg_n_Wrap(testu700,0)
comp_v700=dim_avg_n_Wrap(testv700,0)


wks = gsn_open_wks("png","Anomaly_winds_WD0_GTE15")         ; send graphics to PNG file

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




end
