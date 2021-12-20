begin


;;;;;;;; input files

fin950z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z950_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z950_old=fin950z->z(:,{21:35},{64:96})
printVarSummary(z950_old)
time=fin950z->time
units=z950_old&time@units

;;;;;;; Convert to appropriate units
z950=z950_old/9.81

copy_VarMeta(z950_old,z950)

nyears=dimsizes(ispan(1979,2014,1))
ntimes=nyears*2*31

outString=new((ntimes+1),"string")
outString(0)="year-mn-d,fogstations,65_70_31_34,71_80_31_34,81_90_31_34,91_95_31_34,65_70_26_30,71_80_26_30,81_90_26_30,91_95_26_30,65_70_22_25,71_80_22_25,81_90_22_25,91_95_22_25"
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
  
   npoints1= num(z950({JTime},{31:34},{65:70}).lt.-1.0)
   npoints2= num(z950({JTime},{31:34},{71:80}).lt.-1.0)
   npoints3= num(z950({JTime},{31:34},{81:90}).lt.-1.0)
   npoints4= num(z950({JTime},{31:34},{91:95}).lt.-1.0)
   npoints5= num(z950({JTime},{26:30},{65:70}).lt.-1.0)
   npoints6= num(z950({JTime},{26:30},{71:80}).lt.-1.0)
   npoints7= num(z950({JTime},{26:30},{81:90}).lt.-1.0)
   npoints8= num(z950({JTime},{26:30},{91:95}).lt.-1.0)
   npoints9= num(z950({JTime},{22:25},{65:70}).lt.-1.0)
   npoints10= num(z950({JTime},{22:25},{71:80}).lt.-1.0)
   npoints11= num(z950({JTime},{22:25},{81:90}).lt.-1.0)
   npoints12= num(z950({JTime},{22:25},{91:95}).lt.-1.0)

   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1+","+npoints2+","+npoints3+","+npoints4+","+npoints5+","+npoints6+","+npoints7+","+npoints8+","+npoints9+","+npoints10+","+npoints11+","+npoints12
   in=in+1
  end do
 end do
end do


asciiwrite ("LowFogDetails_1979to2014_950hPa.txt",outString)












end
