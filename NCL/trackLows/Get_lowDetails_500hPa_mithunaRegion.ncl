begin


;;;;;;;; input files

fin500z=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_z500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
z500_old=fin500z->z(:,{25:40},{60:80})
printVarSummary(z500_old)
time=fin500z->time
units=z500_old&time@units

;;;;;;; Convert to appropriate units
z500=z500_old/9.81

copy_VarMeta(z500_old,z500)

nyears=dimsizes(ispan(1979,2014,1))
ntimes=nyears*2*31

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
  
   npoints1= num(z500({JTime},{:},{:}).lt.-9.0)
   
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1
   in=in+1
  end do
 end do
end do


asciiwrite ("LowMithuna_1979to2014_500hPa.txt",outString)












end
