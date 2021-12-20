begin

;;;;;;;; input files

fin500t=addfile("/home/cccr/rameshv/dipti/Data/eraDown/AnomERA5PerDay_.75_decJan_1979_2018_t500_download.nc","r")


;*******fog data
fogfile=addfile("/home/cccr/rameshv/dipti/Data/CombineStation_fog_data_24.nc","r")
fogdata=fogfile->fogdata
printVarSummary(fogdata)

;;;;;;;;; Read Variables
t500_old=fin500t->t
printVarSummary(t500_old)
time=fin500t->time
units=t500_old&time@units

t500=t500_old

nyears=dimsizes(ispan(1979,2014,1))
ntimes=nyears*2*31

outString=new((ntimes+1),"string")
outString(0)="year-mn-d,fogstations,gietelman_midlatitude_instability"
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

   npoints1= avg(t500({JTime},{30:35},{20:100}))-avg(t500({JTime},{50:55},{20:100}))
   
   outString(in)=yr+"-"+mn+"-"+d+","+sum(fogdata({:},{yr},{mn},{d}))+","+npoints1
   in=in+1
  end do
 end do
end do


asciiwrite ("InstabilityIndex_MadhuraGietelman_1979to2014_500hPa.txt",outString)

end