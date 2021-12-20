begin
latS=10
latN=35
lonL=70
lonR=95

f=addfile("/home/cccr/rameshv/dipti/pySom/Data/ER5_level_DecJan_1979-2019_00_Down.nc","r")
u10=short2flt(f->u(:,{950},{latS:latN},{lonL:lonR}))
v10=short2flt(f->v(:,{950},{latS:latN},{lonL:lonR}))

printVarSummary(u10)
printVarSummary(v10)
units=u10&time@units


data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_2.5ddCriteriaRF50Per.txt",1059,"string")
delim=","
dates=str_get_field(data, 1, delim)
stations=toint(str_get_field(data, 3, delim))
gridpoints=toint(str_get_field(data, 2, delim))
delim="-"
year=toint(str_get_field(dates, 1, delim))
months=toint(str_get_field(dates, 2, delim))
days=toint(str_get_field(dates, 3, delim))
;print(days)

;print(stations)
;exit


;;;;;;;;;;; get count 
labelCount=new(2,"integer")
labelCount=0

do i=0,dimsizes(data)-1

   if (stations(i).le.6) then
   labelCount(0)=labelCount(0)+1
   end if
   if (stations(i).ge.10) then
   labelCount(1)=labelCount(1)+1
   end if

end do

print(labelCount)

u10l=new((/labelCount(0),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),float)
v10l=new((/labelCount(0),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),float)
u10m=new((/labelCount(1),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),float)
v10m=new((/labelCount(1),dimsizes(u10(0,:,0)),dimsizes(u10(0,0,:))/),float)

l=0
m=0
do i=0,dimsizes(data)-1

Time=cd_inv_calendar(year(i),months(i),days(i),0,0,0,units,0)

   if (stations(i).le.6) then
    u10l(l,:,:)=u10({Time},:,:)
    v10l(l,:,:)=v10({Time},:,:)
    l=l+1
   end if
   if (stations(i).ge.10) then
    u10m(m,:,:)=u10({Time},:,:)
    v10m(m,:,:)=v10({Time},:,:)
     m=m+1
   end if

end do

u10lavg=dim_avg_n_Wrap(u10l,0)
v10lavg=dim_avg_n_Wrap(v10l,0)
u10mavg=dim_avg_n_Wrap(u10m,0)
v10mavg=dim_avg_n_Wrap(v10m,0)


u10Diff=u10lavg
u10Diff=u10mavg-u10lavg
v10Diff=v10lavg
v10Diff=v10mavg-v10lavg


;---Create plot
  wks = gsn_open_wks("png","vector950")               ; send graphics to PNG file

  vcres                         = True             ; plot mods desired
;  vcres@gsnFrame                = False            ; so we can draw time stamp
  vcres@vcRefAnnoOrthogonalPosF = -1.0             ; move ref vector up
;  vcres@vcRefMagnitudeF         = 10.0             ; define vector ref mag
;  vcres@vcRefLengthF            = 0.045            ; define length of vec ref
;  vcres@vcGlyphStyle            = "CurlyVector"    ; turn on curly vectors
 ; vcres@vcMinDistanceF          = 0.017
  vcres@gsnAddCyclic=False
   vcres@mpMinLonF            =  lonL               ; select a subregion
  vcres@mpMaxLonF            =  lonR
  vcres@mpMinLatF            =   latS
 vcres@mpMaxLatF            =  latN

  vector = gsn_csm_vector_map(wks,u10Diff,v10Diff,vcres)







end
