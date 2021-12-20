begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{20:45},{55:85})
printVarSummary(z500_old)
time=fin500z->time
units=z500_old&time@units


;print(z500&latitude)
;print(z500&longitude)

;exit

;;;;;;; Convert to appropriate units
z500=z500_old/9.81

copy_VarMeta(z500_old,z500)
dims=dimsizes(z500)
nyears=dimsizes(ispan(1979,2014,1))
ntimes=nyears*2*31

print(z500&latitude)
print(z500&longitude)

;exit


outString=new((ntimes+1),"string")
outString(0)="year-mn-d,fogstations,60_80_25_40"
in=1
npoints=0
do yr=1979,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
  
   npoints1= min(z500({JTime},{:},{:}))
   
    x1d = ndtooned(z500({JTime},{:},{:}))      ; convert 2D array to 1D for use in minind
  inds = ind_resolve(minind (x1d), dims)    ; convert 1D array back to 2D 
  print(inds)
  ilat = inds(0,1)        ; select the latitude index where the X array is at its' minimum  
  ilon = inds(0,2)        ; select the longitude index where the X array is at its' minimum  
  lat_min = z500&latitude(ilat)   ; insert the latitude index into the lat coordinate variable
  lon_min = z500&longitude(ilon)   ; insert the longitude index into the lon coordinate variable
   
   npoints2=lat_min+","+ lon_min    
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1+","+npoints2
delete(lat_min)
delete(lon_min)
   in=in+1
  end do
 end do
end do


asciiwrite ("LowCentre_1979to2014_500hPa.txt",outString)












end
