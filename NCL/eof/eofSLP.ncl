begin
  
  latS   =  10.
  latN   = 40.  
  lonL   = 60.
  lonR   = 100.
  neof=5

f=addfile("/home/cccr/rameshv/dipti/Data/357WDFDaysMSLP.nc","r")

t2m=f->dd(:,{latS:latN},{lonL:lonR})
  printVarSummary(t2m)
 x      = t2m({latitude|latS:latN},{longitude|lonL:lonR},{time|:}) 
 optEOF = True       
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
eof      = eofunc_Wrap(x, neof, optEOF) 

printVarSummary(eof)

;============================================================
; PLOTS
;============================================================
  wks = gsn_open_wks("png","rfeofmslp")         ; send graphics to PNG file
  plot = new(neof,graphic)                ; create graphic array
                                          ; only needed if paneling
; EOF patterns

  res                      = True         
  res@gsnDraw              = False        ; don't draw yet
  res@gsnFrame             = False        ; don't advance frame yet

  res@gsnAddCyclic         = False        ; plotted dataa are not cyclic
 
  res@mpFillOn             = False        ; turn off map fill
  res@mpMinLatF            = latS         ; zoom in on map
  res@mpMaxLatF            = latN
  res@mpMinLonF            = lonL
  res@mpMaxLonF            = lonR

  res@cnFillOn             = True         ; turn on color fill
  res@cnLinesOn            = False        ; True is default
 ;res@cnLineLabelsOn       = False        ; True is default
  res@cnFillPalette        = "BlWhRe"     ; set color map
  res@lbLabelBarOn         = False        ; turn off individual lb's

                                          ; set symmetric plot min/max
  symMinMaxPlt(eof, 16, False, res)       ; contributed.ncl

; panel plot only resources
  resP                     = True         ; modify the panel plot
  resP@gsnMaximize         = True         ; large format
  resP@gsnPanelLabelBar    = True         ; add common colorbar


;*******************************************
; first plot
;*******************************************
  do n=0,neof-1
     res@gsnLeftString  = "EOF "+(n+1)
     res@gsnRightString = sprintf("%5.1f", eof@pcvar(n)) +"%"
     plot(n)=gsn_csm_contour_map(wks,eof(n,:,:),res)
  end do
  gsn_panel(wks,plot,(/neof,1/),resP)     ; now draw as one plot

end
