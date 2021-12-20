begin

;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")
fin700z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z700_download.nc","r")
fin300z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z300_download.nc","r")
fin950z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z950_download.nc","r")



;;;;;;;;; Read Variables
z500_old=fin500z->z
z700_old=fin700z->z
z300_old=fin300z->z
z950_old=fin950z->z


;;;;;;; Convert to appropriate units
z500=z500_old/9.81
z700=z700_old/9.81
z300=z300_old/9.81
z950=z950_old/9.81

copy_VarMeta(z500_old,z500)
copy_VarMeta(z950_old,z950)
copy_VarMeta(z300_old,z300)
copy_VarMeta(z700_old,z700)

units=z500&time@units

;;;;;;;;; read dates

;print(Dates)

data=asciiread("Dates.txt",-1,"string")

print(data)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testz500=new((/dimsizes(data),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))
testz950=new((/dimsizes(data),dimsizes(z950(0,:,0)),dimsizes(z950(0,0,:))/),typeof(z950))
testz700=new((/dimsizes(data),dimsizes(z700(0,:,0)),dimsizes(z700(0,0,:))/),typeof(z700))
testz300=new((/dimsizes(data),dimsizes(z300(0,:,0)),dimsizes(z300(0,0,:))/),typeof(z300))



;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(data)-1

	JTime=cd_inv_calendar(year(i),month(i),day(i),9,00,00,units,0)
	testz500(i,:,:)=z500({JTime},:,:)
		testz700(i,:,:)=z700({JTime},:,:)
       	testz950(i,:,:)=z950({JTime},:,:)
        testz300(i,:,:)=z300({JTime},:,:)
        
end do

;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,0)
comp_z950=dim_avg_n_Wrap(testz950,0)
comp_z300=dim_avg_n_Wrap(testz300,0)
comp_z700=dim_avg_n_Wrap(testz700,0)


wks = gsn_open_wks("png","AnomalyZ_levels_post98_LTE6_WD")         ; send graphics to PNG file

  vcres                         = True             ; plot mods desired
  vcres@gsnFrame                = False            ; so we can draw time stamp
  vcres@gsnDraw      =  False                   ; do not draw the plot
;  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
  ;vcres@vcRefLengthF            = 0.045            ; define length of vec ref
  ;vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  ;vcres@vcMinDistanceF          = 0.017
  vcres@mpMinLonF            =  0.               ; select a subregion
  vcres@mpMaxLonF            =  120.
  vcres@mpMinLatF            =   0. 
  vcres@mpMaxLatF            =  60. 
 ; vcres@vcRefMagnitudeF         = 10.0
  vcres@gsnLeftString =" "
  vcres@gsnCenterString = "500hPa z "  
  vcres@cnMinLevelValF  = -80.0                    ; set the minimum contour level
  vcres@cnMaxLevelValF  = 80.0                   ; set the maximum contour level
  vcres@cnLevelSpacingF = 5.0                     ; set the interval between contours
  plot500 = gsn_csm_contour_map(wks,comp_z500,vcres)
  plot500 = ColorNegDashZeroPosContour(plot500,"red","magenta","blue")
  ;plot500=gsn_csm_vector_map(wks,comp_z500,comp_v500,vcres)
  
  vcres@cnMinLevelValF  = -120.0                    ; set the minimum contour level
  vcres@cnMaxLevelValF  = 120.0                   ; set the maximum contour level
  ;vcres@vcRefMagnitudeF         = 5.0
  vcres@gsnCenterString = "300hPa z "  
  plot300 = gsn_csm_contour_map(wks,comp_z300,vcres)
  plot300 = ColorNegDashZeroPosContour(plot300,"red","magenta","blue")
  
  vcres@cnMinLevelValF  = -80.0                    ; set the minimum contour level
  vcres@cnMaxLevelValF  = 80.0                   ; set the maximum contour level
  ;vcres@vcRefMagnitudeF         = 2.0
  vcres@gsnCenterString = "700hPa z "  
  plot700 = gsn_csm_contour_map(wks,comp_z700,vcres)
  plot700 = ColorNegDashZeroPosContour(plot700,"red","magenta","blue")
  
  vcres@cnMinLevelValF  = -50.0                    ; set the minimum contour level
  vcres@cnMaxLevelValF  = 50.0                   ; set the maximum contour level
  ;vcres@vcRefMagnitudeF         = 1.0
  vcres@gsnCenterString = "950hPa z "  
  plot950 = gsn_csm_contour_map(wks,comp_z950,vcres)
  plot950 = ColorNegDashZeroPosContour(plot950,"red","magenta","blue")
  
  ;;;;;;;;;;;;;;;;;; panel resources
  resP                = True                ; panel only resources
  resP@gsnMaximize    = True                ; maximize plots
  resP@gsnPanelMainString="AnomalyZ levels post98 LTE6 WD"
  gsn_panel(wks,(/plot300,plot500,plot700,plot950/),(/2,2/),resP)          ; now draw as one plot




end
