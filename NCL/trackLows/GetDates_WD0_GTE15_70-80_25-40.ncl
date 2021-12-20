begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{25:40},{70:80})
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old/9.81

copy_VarMeta(z500_old,z500)

nyears=dimsizes(ispan(1998,2014,1))
ntimes=nyears*2*31
;;;;;;;;;;;;;;; Get Counts Days
npoints=0
cnt15=0
cnt3=0
do yr=1998,2014
 do mon=1,2
  if(mon.eq.2)then
    mn=12
  else
    mn=mon
  end if
  do d=1,31
    JTime=cd_inv_calendar(yr,mn,d,9,00,00,units,0)

   npoints= num(z500({JTime},:,:).lt.-10.0)
   if(npoints.eq.0 .and. sum(fogdata({:},{yr},{mn},{d})).ge.15) then
     cnt15=cnt15+1
   end if  
  if(npoints.eq.0 .and. sum(fogdata({:},{yr},{mn},{d})).le.3) then
     cnt3=cnt3+1
   end if

; outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints
 ;  in=in+1
  end do
 end do
end do

print(cnt15)
print(cnt3)


outString15=new((cnt15),"string")
outString3=new((cnt3),"string")

in15=0
in3=0
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
  
   npoints= num(z500({JTime},:,:).lt.-10.0)
   if(npoints.eq.0)then
    if(sum(fogdata({:},{yr},{mn},{d})).ge.15)then
    outString15(in15)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints
    in15=in15+1
    end if
    if(sum(fogdata({:},{yr},{mn},{d})).le.3)then
    outString3(in3)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints
    in3=in3+1
    end if

   end if
  end do
 end do
end do


asciiwrite ("WD0_DatesGTE15.txt",outString15)
asciiwrite ("WD0_DatesLTE3.txt",outString3)












end
