begin

f= addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_MSLP_DecJan_1979-2019_0_Down.nc","r")

slp=short2flt(f->msl)

printVarSummary(slp)


slp=slp/100.0

time=f->time

units=time@units

printVarSummary(slp)


p1=slp(:,{38},{77})
p2=slp(:,{38},{82})
p3=slp(:,{33},{72})
p4=slp(:,{33},{77})
p5=slp(:,{33},{82})
p6=slp(:,{33},{87})
p7=slp(:,{28},{72})
p8=slp(:,{28},{77})
p9=slp(:,{28},{82})
p10=slp(:,{28},{87})
p11=slp(:,{23},{72})
p12=slp(:,{23},{77})
p13=slp(:,{23},{82})
p14=slp(:,{23},{87})
p15=slp(:,{18},{77})
p16=slp(:,{18},{82})


outTxt=new(dimsizes(slp(:,0,0)),"string")

do i=0,dimsizes(slp(:,0,0))-1

;;;;;;;get date

date=tostring(cd_calendar(time(i),-2))
print(date)

;;;;;; decide LWT

end do

end
