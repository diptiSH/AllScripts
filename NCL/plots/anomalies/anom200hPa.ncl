begin

;;;;;;;; input files

fin200=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/200Data_00/ER5_200hPa_pl_DecJan_1979-2019_0_Down.nc","r")

u=short2flt(fin200->u)
v=short2flt(fin200->v)
units=u&time@units
printVarSummary(u)
printVarSummary(v)

;;;;;;;;; read Dates to make composites

;print(Dates)

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_1.5ddCriteriaRF50Per.txt",-1,"string")
delim=","
Dates=str_get_field(data, 1, delim)
delim="-"
year=toint(str_get_field(Dates, 1, delim))
month=toint(str_get_field(Dates, 2, delim))
day=toint(str_get_field(Dates, 3, delim))

;;;;;;;;; Define variables to hold values before making composites
testu=new((/dimsizes(Dates),dimsizes(u(0,:,0)),dimsizes(u(0,0,:))/),typeof(u))
testv=new((/dimsizes(Dates),dimsizes(u(0,:,0)),dimsizes(u(0,0,:))/),typeof(u))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(Dates)-1

        JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
        testu(i,:,:)=u({JTime},:,:)
        testv(i,:,:)=v({JTime},:,:)
end do

;;;;;;;;; Average over time to get composite values
comp_u=dim_avg_n_Wrap(testu,0)
comp_v=dim_avg_n_Wrap(testv,0)

comp_wind_speed=wind_speed(comp_u,comp_v)

;---Create plot
;  wks = gsn_open_wks("png","vector")               ; send graphics to PNG file

 ; cmap = read_colormap_file("BlAqGrYeOrReVi200")

  ;vcres                     = True      ; plot mods desired
  ;vcres@lbLabelStride       = 2         ; plot every other colar bar label
  ;vcres@vcRefMagnitudeF         = 5.0              ; make vectors larger
  ;vcres@vcRefLengthF            = 0.050            ; ref vec length
  ;vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
  ;vcres@vcMinDistanceF          = 0.017            ; thin out vectors
  ;vcres@vcLevelPalette      = cmap(6:193,:)

  ;vcres@tiMainString            = "Vectors colored by a scalar map"
  ;vcres@gsnPolar   = "NH" 
  ;vcres@mpCenterLonF = 80

  ;plot=gsn_csm_vector_scalar_map_ce(wks,comp_u,comp_v,comp_wind_speed,vcres)  ; create plot


;---create plot
  wks = gsn_open_wks("png" ,"stream")           ; send graphics to PNG file
;  gsn_define_colormap(wks,"wgne15")             ; choose colormap

  res            = True                         ; plot mods desired
  res@gsnPolarNH = True                         ; specify the hemisphere
;  res@mpMinLatF  = 60                           ; minimum lat to plot
  res@mpFillOn   = False

  res@cnFillOn          = True                  ; color fill
  res@cnLevelSpacingF   = 3.                    ; interval spacing
  res@cnLinesOn         = False                 ; no contour lines

  res@stLineColor = "white"
;  res@stLineThicknessF = 1.5

;  res@gsnSpreadColors     = True                ; use full colormap
;  res@gsnSpreadColorStart = 2 
;  res@gsnSpreadColorEnd   = -3 

 res@stArrowLengthF     = 0.008                ; default is dynamic
 res@stLengthCheckCount = 5                    ; default is 35
 res@stArrowStride      = 1
 res@stLineStartStride  = 1                    ; default is 2
 res@stMinArrowSpacingF = 0.03                 ; default is 0.0             
res@stStepSizeF        = 0.001                ; default is dynamic

res@stMinDistanceF     = 0.03                 ; distance between lines
res@stMinLineSpacingF  = 0.005                

; because this is ice data, which has a gap in the tropics, we need to
; explicitly pass the range of the data to plot.  Since we are coloring 
; the vectors, this range should also match the MinLatF above, since the
; range for the colors is chosen over the full data passed, and not the
; map limits.

  plot = gsn_csm_streamline_contour_map_polar(wks,comp_u({0.:90.},:),comp_v({0.:90.},:), comp_wind_speed({0.:90.},:),res)



end
