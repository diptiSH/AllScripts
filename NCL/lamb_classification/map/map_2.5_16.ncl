
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl" 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
load "./shapefile_utils.ncl"

;--------------------------------------------------------------------------------
; 
;--------------------------------------------------------------------------------
procedure add_co_cities(wks,map)
local cities, city_lats, city_lons, mkres, txres
begin
   

  mkres               = True
  txres               = True
  mkres@gsMarkerSizeF = 10
  mkres@gsMarkerIndex = 16
  txres@txFontHeightF = 0.005  ; 0.02 if part of smaller map
     delim=","
     stationData=asciiread("station_details.csv",-1,"string")
     cities=str_get_field(stationData, 2, delim)
     lat=stringtofloat(str_get_field(stationData, 3, delim))
     lon=stringtofloat(str_get_field(stationData, 4, delim))
    
  txres@txFont = "helvetica"
  txres@txJust = "BottomRight"
  map@cities_tx = gsn_add_text(wks,map,cities,lon,lat+0.05,txres)
end

begin
     delim=","
     stationData=asciiread("station_details.csv",-1,"string")
     print(stationData)
    ; cities=str_get_field(stationData, 1, delim)
      input=stringtofloat(str_get_field(stationData, 4, delim))
     lat=stringtofloat(str_get_field(stationData, 3, delim))
     print(lat)
     lon=stringtofloat(str_get_field(stationData, 4, delim))
     print(lon)
;print(cities)



  
 

;print(fname)


sname = "india_st.shp"
print_shapefile_info(sname)
plot_shapefile(sname)

;

;===========================================================================
; Begin plotting section.
;
  wks = gsn_open_wks("png","5_2.5_16_stations_fog_days")              ; send graphics to PNG file
  gsn_define_colormap(wks,"WhViBlGrYeOrRe")      ; define a different color map
                
;
; Set up some map resources.
;
  mpres              = True
  mpres@gsnMaximize  = False             ; Maximize plot in frame.
  mpres@gsnFrame     = False            ; Don't advance the frame
  mpres@gsnDraw     = False            ; Don't Draw the frame
 
 mpres@mpOutlineOn = False ; turn off map outlines
  mpres@mpOutlineBoundarySets = "National"
 mpres@mpGridAndLimbOn = True 
mpres@mpGridLatSpacingF      = 5.
  mpres@mpGridLonSpacingF      = 5.
;
; Zoom in on India.
;
  mpres@mpMinLatF    = 15.
  mpres@mpMaxLatF    = 45.
  mpres@mpMinLonF    = 60.
  mpres@mpMaxLonF    = 100.
mpres@mpFillColors = (/"transparent","transparent", \
  "transparent","transparent"/)    ;assign light gray to land masses

mpres@mpNationalLineThicknessF = 2.0 ; interior boundaries 
  mpres@mpGeophysicalLineThicknessF = 1.0 ; lines separating land/ocean 
mpres@tiMainString = "fog days "
mpres@txFontHeightF = 0.013
mpres@gsnLeftString = " " 
mpres@gsnRightString = " "
  map1 = gsn_csm_map_ce(wks,mpres)



;
;  Create logical variables to hold the marker and text resources.
;  These markers are different than the XY markers, because they are not
;  associated with an XY plot. You can put these markers on any plot.
;
  gsres               = True
  gsres@gsMarkerIndex = 16          ; Use filled dots for markers.
 gsres@gsMarkerSizeF          =  0.004        ;-- set size of marker
;gsres@gsMarkerColor          = "purple"       ;-- marker color
gsres@gsMarkerIndex   = 16

minIn=min(input)
maxIn=max(input)
ran=(maxIn-minIn)/5.0

cl1=minIn+ran
cl2=cl1+ran
cl3=cl2+ran
cl4=cl3+ran

 
do i=0,dimsizes(stationData)-1

if(input(i) .lt. cl1) then
 gsres@gsMarkerColor          = "red"      ;-- marker color
else if(input(i) .ge. cl1 .and. input(i) .lt. cl2 ) then
 gsres@gsMarkerColor          = "red"      ;-- marker color
else if(input(i) .ge. cl2 .and. input(i) .lt. cl3 ) then
 gsres@gsMarkerColor          = "red"      ;-- marker color
else if(input(i) .ge. cl3 .and. input(i) .lt. cl4 ) then
 gsres@gsMarkerColor          = "red"      ;-- marker color
else
  gsres@gsMarkerColor          = "red"      ;-- marker color
end if
end if
end if
end if


gsn_polymarker(wks,map1,lon(i),lat(i),gsres)
 end do

;add_co_cities(wks,map1)

colors=(/"red","red","red","red","red"/)
labels=(/"x<"+cl1,cl1+"<=x<"+cl2,cl2+"<=x<"+cl3,cl3+"<=x<"+cl4,"x>="+cl4/)
txres               = True
  txres@txFontHeightF = 0.012

 xleg = (/0.07,0.07,0.32,0.32,0.57,0.57/)   ; Location of
  xtxt = (/0.16,0.16,0.41,0.41,0.66,0.66/)   ; legend markers
  yleg = (/0.14,0.10,0.14,0.10,0.14,0.10/)   ; and text
  ytxt = (/0.14,0.10,0.14,0.10,0.14,0.10/)   ; strings.

do i=0,4
;
; Add marker and text for the legend.
      gsres@gsMarkerColor      = colors(i)
      gsres@gsMarkerIndex   = 16
      ;gsn_polymarker_ndc(wks,          xleg(i),yleg(i),gsres)
      ;gsn_text_ndc      (wks,labels(i),xtxt(i),ytxt(i),txres)

end do

    lnres                  = True
     lnres@gsLineThicknessF = 1.0
     lnres@gsLineColor      = "Black"
   ;  ind_adm1 = gsn_add_shapefile_polylines(wks,plot(0),"IND_adm/IND_adm1.shp",lnres)
     ind_adm2 = gsn_add_shapefile_polylines(wks,map1,"india_st.shp",lnres)

;;;;;;;;;;;; Marker resources

  polyres                   = True
   polyres@gsMarkerIndex     = 16          ; polymarker style
   polyres@gsMarkerSizeF     = 7.          ; polymarker size
;;;;;;;;;;;;;;;text resources
 tres                      = True                ; text mods desired
  tres@txFontHeightF        = 0.015               ; make smaller

dum1=new(16,"graphic")
dum=new(16,"graphic")
;glon=(/78,80.5,75.5,78,80.5,83,75.5,78,80.5,83,75.5,78,80.5,83,78,80.5/)
glon=(/77,82,72,77,82,87,72,77,82,87,72,77,82,87,77,82/)
glat=(/31,31,28.5,28.5,28.5,28.5,26,26,26,26,23.5,23.5,23.5,23.5,21,21/)
do i=0,15
 j=i+1
 dum1(i)    = gsn_add_polymarker(wks,map1,glon(i),glat(i),polyres)
  dum(i) = gsn_add_text(wks,map1,"P"+j,glon(i),glat(i)+0.5,tres)
end do

draw(map1) 

frame(wks)    ; Advance the frame.

end




