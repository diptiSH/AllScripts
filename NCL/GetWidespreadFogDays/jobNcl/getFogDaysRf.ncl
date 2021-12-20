begin

ftlevel=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ER5_T_pl_DecJan_1979-2019_0_Down.nc","r")
fsurface=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ER5_t2md2m_NovDecJan_1979-2019_0_Down.nc","r")
foro=addfile("/home/cccr/rameshv/dipti/Data/ERA5/era5Orography.nc","r")
frf=addfile("/home/cccr/rameshv/dipti/pySom/Data/rf_imd_1979_2016_Dec_Jan.nc","r")


tsurf=short2flt(fsurface->t2m(:,{23:32},{73:86}))
dsurf=short2flt(fsurface->d2m(:,{23:32},{73:86}))
t=short2flt(ftlevel->t(:,:,{23:32},{73:86}))
rf=frf->rf
oro=short2flt(foro->z(:,{23:32},{73:86}))
lats=tsurf&latitude
lons=tsurf&longitude
time2=frf->time
units2=time2@units


printVarSummary(tsurf)
printVarSummary(dsurf)
printVarSummary(t)
printVarSummary(oro)


gridNums=num(.not.ismissing(oro))

print(num((oro/9.81).lt.500.0))
gridNums=num((oro/9.81).lt.500.0)



print(lats)
print(lons)

;exit

units=t&time@units

print(units)

;;;;;;;;;;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

years=ispan(1980,2019,1)
foggypts=new(dimsizes(years)*62,"string")
WSfogDates=new(586,"string")

i=0
ii=0
do y=1980,2016
   print(y)
 do m=2,1,1
   ; print(m)
    if(m.eq.2)then
      yr=y-1
      mn=12
    else
      yr=y
      mn=m
    end if
    do d=1,31
        ;print(tostring(y)+"-"+tostring(mn)+"-"+tostring(d))
       Time=cd_inv_calendar(yr,mn,d,0,0,0,units,0)
       Time2=cd_inv_calendar(yr,mn,d,00,00,00,units2,0)
       fg_points=0
       do la=0,dimsizes(lats)-1
         do lo=0,dimsizes(lons)-1
           lat=lats(la)
           lon=lons(lo) 
           if((oro(0,{lat},{lon})/9.81) .le. 500.0)then
                     ; print(tostring(yr)+tostring(mn)+tostring(d))
                  dd=(tsurf({Time},{lat},{lon})-dsurf({Time},{lat},{lon}))
                  r=rf({Time2},{lat},{lon})
                  inv1=tsurf({Time},{lat},{lon})-t({Time},{1000},{lat},{lon})
                  inv2=t({Time},{1000},{lat},{lon})-t({Time},{975},{lat},{lon})
                  inv3=t({Time},{975},{lat},{lon})-t({Time},{950},{lat},{lon})
                  inv4=t({Time},{950},{lat},{lon})-t({Time},{925},{lat},{lon})
                  inv5=t({Time},{925},{lat},{lon})-t({Time},{900},{lat},{lon})
                  inv6=t({Time},{900},{lat},{lon})-t({Time},{875},{lat},{lon})
                  inv7=t({Time},{875},{lat},{lon})-t({Time},{850},{lat},{lon})
                  invArray=(/inv1,inv2,inv3,inv4,inv5,inv6,inv7/)
                  inv=min(invArray)
                if(.not.ismissing(r))then
                if(dd.lt.1.5 .and. inv.lt.0.0 .and. r.le.0.0)then
                   fg_points=fg_points+1
                end if
                end if
         end if
         end do
      end do
         ;print(r)
         ;print(fg_points)
        if(1.0*fg_points/gridNums .gt. 0.5)then
       if (yr.lt.2017)then

           WSfogDates(ii)=tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points+","+tostring(sum(fogdata({:},{yr},{mn},{d})))
;print( WSfogDates(ii))
           ii=ii+1
     else
         WSfogDates(ii)=tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points
           ii=ii+1
   end if
           if (yr.lt.2017)then
             foggypts(i)="**,"+tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points+","+tostring(sum(fogdata({:},{yr},{mn},{d})))
           else
             foggypts(i)="**,"+tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points
           end if
     else
          if (yr.lt.2017)then
             foggypts(i)=tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points+","+tostring(sum(fogdata({:},{yr},{mn},{d})))
           else
             foggypts(i)=tostring(yr)+"-"+tostring(mn)+"-"+tostring(d)+","+fg_points
           end if
     end if
     i=i+1
    end do
  end do
end do

asciiwrite("2ogDays_1.5ddCriteriarf.txt",foggypts)
asciiwrite("WSFogDays_1.5ddCriteriaRF50Per.txt",WSfogDates)

end
