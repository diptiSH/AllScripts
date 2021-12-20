begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/StdAnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{0:40},{65:100})
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old

copy_VarMeta(z500_old,z500)


dims=dimsizes(z500(0,:,:))


;;;get counts
cntAll=0
cnt=0
cnt0_neg1=0
cntneg1=0
cnt0_pos1=0
cntpos1=0


npoints=0.0
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
   npoints= avg(z500({JTime},{30:40},{65:75}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).ge.12)then

       cntAll=cntAll+1

      if(npoints.eq.0)then
       cnt=cnt+1
      end if   

     if(npoints.lt.0 .and. npoints.gt.-1)then
       cnt0_neg1=cnt0_neg1+1
      end if 

    if(npoints.le.-1)then
       cntneg1=cntneg1+1
      end if 

if(npoints.gt.0 .and. npoints.lt.1)then
       cnt0_pos1=cnt0_pos1+1
      end if 

    if(npoints.ge.1)then
       cntpos1=cntpos1+1
      end if 

    end if

  end do
 end do
end do
;;;;;;;;;;;; get outstring
outString=new((cntAll),"string")
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
   npoints= avg(z500({JTime},{30:40},{65:75}))
;;;criteria
    if(sum(fogdata({:},{yr},{mn},{d})).ge.12)then


        outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints
       in=in+1

    end if

  end do
 end do
end do


print("GTE12 days - "+cntAll)
print("GTE12 days 0 - "+cnt)
print("GTE12 days 0to-1 - "+cnt0_neg1)
print("GTE12 days le-1 - "+cntneg1)
print("GTE12 days 0to1 - "+cnt0_pos1)
print("GTE12 days ge1 - "+cntpos1)

asciiwrite ("Dates_GTE12.txt",outString)
delete(outString)


end
