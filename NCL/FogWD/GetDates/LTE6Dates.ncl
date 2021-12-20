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


dims=dimsizes(z500(0,:,:))
;;;;;;;;;;;;;;;;;; ET0
;;;get counts
cnt=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

;      if(npoints.gt.0)then
       cnt=cnt+1
 ;     end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

;      if(npoints.gt.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
 ;     end if   
    end if

  end do
 end do
end do


print("LTE6 days - "+cnt)
asciiwrite ("Dates_LTE6.txt",outString)
delete(outString)

;;;; ET0 WD

;;;get counts
cnt=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
     end if   
    end if

  end do
 end do
end do


print("LTE6 days WD - "+cnt)
asciiwrite ("Dates_LTE6_WD.txt",outString)
delete(outString)

;;;; ET0 WD

;;;get counts
cnt=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1979,2014
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
     end if   
    end if

  end do
 end do
end do


print("LTE6 days NOWD - "+cnt)
asciiwrite ("Dates_LTE6_NOWD.txt",outString)
delete(outString)


;;;;;;;;;; pre 98 WD
;;;get counts
cnt=0
npoints=0
do yr=1979,1997
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.1997) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1979,1997
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.1997) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
      end if   
    end if

  end do
 end do
end do


print("LTE6_pre98_WD days - "+cnt)
asciiwrite ("Dates_LTE6_pre98_WD.txt",outString)
delete(outString)

;;;;;;;;;; post 98 WD
;;;get counts
cnt=0
npoints=0
do yr=1997,2014
  if(yr.eq.1997) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do

;print(cnt)
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1997,2014
  if(yr.eq.1997) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    ;print(in)
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.gt.0)then
   ;     print(sum(fogdata({:},{yr},{mn},{d})))
    ;    print(npoints)
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
      end if   
    end if

  end do
 end do
end do


print("LTE6_post98_WD days - "+cnt)
asciiwrite ("Dates_LTE6_post98_WD.txt",outString)
delete(outString)

;;;;;;;;;; pre 98 NOWD
;;;get counts
cnt=0
npoints=0
do yr=1979,1997
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.1997) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1979,1997
  if(yr.eq.1979) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.1997) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
      end if   
    end if

  end do
 end do
end do


print("LTE6_pre98_NOWD days - "+cnt)

asciiwrite ("Dates_LTE6_pre98_NOWD.txt",outString)
delete(outString)

;;;;;;;;;; post 98 NOWD
;;;get counts
cnt=0
npoints=0
do yr=1997,2014
  if(yr.eq.1997) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
       cnt=cnt+1
      end if   
    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cnt),"string")
in=0
npoints=0
do yr=1997,2014
  if(yr.eq.1997) then
    stMon=2
  else
    stMon=1
  end if

if(yr.eq.2014) then
    edMon=1
  else
    edMon=2
  end if
   
 do mon=stMon,edMon
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)
   npoints= num(z500({JTime},{25:40},{70:80}).lt.-10.0)
   minVal=min(z500({JTime},:,:))
   x=(z500({JTime},:,:))
   minInd=minind(ndtooned(z500({JTime},:,:)))
   minLatLon=ind_resolve(minInd,dims)
   ilat=minLatLon(0,0)
   ilon=minLatLon(0,1)
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).le.6)then

      if(npoints.eq.0)then
        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints+","+minVal+","+x&latitude(ilat)+","+x&longitude(ilon)
       in=in+1
      end if   
    end if

  end do
 end do
end do


print("LTE6_post98_NOWD days - "+cnt)

asciiwrite ("Dates_LTE6_post98_NOWD.txt",outString)
delete(outString)






end
