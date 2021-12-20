begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{0:40},{65:100})
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old/9.81

copy_VarMeta(z500_old,z500)

nyears=dimsizes(ispan(1998,2014,1))
ntimes=nyears*2*31
dims=dimsizes(z500(0,:,:))
outString=new((ntimes),"string")
in=0
npoints=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
;    dims = dimsizes(X)
;  x1d = ndtooned(X)      ; convert 2D array to 1D for use in minind
;  inds = ind_resolve(minind (x1d), dims)    ; convert 1D array back to 2D 
;  ilat = inds(0,0)        ; select the latitude index where the X array is at its' minimum  
;  ilon = inds(0,1)        ; select the longitude index where the X array is at its' minimum  
;  lat_min = X&lat(ilat)   ; insert the latitude index into the lat coordinate variable
;  lon_min = X&lon(ilon)   ; insert the longitude index into the lon coordinate variable  
npoints_25_30_70_90= num(z500({JTime},{25:30},{70:90}).lt. 0.0)
   npointsN30_70_80= num(z500({JTime},{30.25:40},{70:80}).lt. 0.0)
   npoints_26_30_70_80= num(z500({JTime},{26:30},{70:80}).lt. 0.0)
   npoints20_26_70_90= num(z500({JTime},{20:25.75},{70:90}).lt. 0.0)
   npoints_all=num(z500({JTime},{20:40},{70:90}).lt. 0.0)
  ; minVal=min(z500({JTime},:,:))
  ; x=(z500({JTime},:,:))
  ; minInd=minind(ndtooned(z500({JTime},:,:)))
  ; minLatLon=ind_resolve(minInd,dims)
  ; ilat=minLatLon(0,0)
  ; ilon=minLatLon(0,1)
  ; print(minVal)
  ; print(minInd)
  ; print(minLatLon)
  ; print(x&latitude(ilat))
  ; print(x&longitude(ilon))

   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints_25_30_70_90+","+npointsN30_70_80+","+ npoints_26_30_70_80+","+npoints20_26_70_90+","+npoints_all
   in=in+1
  end do
 end do
end do


asciiwrite ("ExtraLowFogDetails_All.txt",outString)












end
