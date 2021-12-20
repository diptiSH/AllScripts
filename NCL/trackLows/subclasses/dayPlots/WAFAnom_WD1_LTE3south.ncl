begin

;;;;;;;; input files

fin300z=addfile("/home/cccr/rameshv/dipti/NCL/waveActivity/ERA5_WAF_DecJan_1979-2018_300hPa.nc","r")


;;;;;;;;;;;;;Read Variables
u500=fin300z->FX
v500=fin300z->FY

printVarSummary(u500)

units=u500&time@units

;;;;;;;;; read dates

;print(Dates)

data=asciiread("Dates_WD1_LTE3south.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testu500=new((/dimsizes(data),dimsizes(u500(0,:,0)),dimsizes(u500(0,0,:))/),typeof(u500))
testv500=new((/dimsizes(data),dimsizes(v500(0,:,0)),dimsizes(v500(0,0,:))/),typeof(v500))


;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testu500(i,:,:)=u500({JTime},:,:)
	testv500(i,:,:)=v500({JTime},:,:)
	

end do

;;;;;;;;; Average over time to get composite values
comp_u500=dim_avg_n_Wrap(testu500,0)
comp_v500=dim_avg_n_Wrap(testv500,0)


wks = gsn_open_wks("png","Anomaly_WAF300hPa_WD1_LTE3south")         ; send graphics to PNG file

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
  plot500=gsn_csm_vector_map(wks,comp_u500,comp_v500,vcres)
  
 




end
