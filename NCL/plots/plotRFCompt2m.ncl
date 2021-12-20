begin
  latS   =  20.
  latN   =  35.
  lonL   = 70.
  lonR   =  90.

fsurface=addfile("/home/cccr/rameshv/dipti/Data/WDF_RF_Dayst2m_forEOF.nc","r")

dd=fsurface->dd(:,{latS:latN},{lonL:lonR})

printVarSummary(dd)


ddavg=dim_avg_n_Wrap(dd,0)

wks = gsn_open_wks("png" ,"t2mRFceComp")      ; send graphics to PNG file

  res                       = True     ; plot mods desired

  res@gsnMaximize           = True     ; Make plot fit the frame
  res@cnFillOn              = True     ; turn on color fill
  res@cnLinesOn             = False    ; turn of contour lines
  res@cnLevelSpacingF       = 0.5      ; contour spacing
  res@cnFillPalette         = "BlAqGrYeOrRe"
  res@lbOrientation         = "Vertical"

  res@gsnAddCyclic          = False    ; data already has cyclic point
				       ; this must also be set for any zoom

;
; Note that the gsn_csm_*map* templates automatically set 
; res@mpLimitMode="LatLon" for you. If you are plotting a 
; different projection, you may have to set this resource.
;
  res@mpMinLatF            = latS      ; range to zoom in on
  res@mpMaxLatF            = latN
  res@mpMinLonF            =  lonL
  res@mpMaxLonF            = lonR
  
  res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = 278.			; set the minimum contour level
  res@cnMaxLevelValF  = 288.			; set the maximum contour level
  res@cnLevelSpacingF = 1.			; set the interval between contours
  res@tiMainString = "Default map tickmark labels"
  plot = gsn_csm_contour_map(wks,ddavg, res)

end
