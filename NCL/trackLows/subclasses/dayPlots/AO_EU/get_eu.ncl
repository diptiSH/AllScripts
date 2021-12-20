begin

infile1=addfile("/home/cccr/rameshv/dipti/NCL/AO_EU/STD145E40N_NORM_ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc","r")
infile2=addfile("/home/cccr/rameshv/dipti/NCL/AO_EU/STD20E55N_NORM_ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc","r")
infile3=addfile("/home/cccr/rameshv/dipti/NCL/AO_EU/STD75E55N_NORM_ERADAILY-1.5deg-500hPa-Dec-Jan-1979-2016.nc","r")


time = infile1->time
printVarSummary(time)



;;;;;;;;; read Dates

data=asciiread("/home/cccr/rameshv/dipti/NCL/trackLows/subclasses/dayPlots/Dates_WD1_LTE3north.txt",-1,"string")


print(data)

 inputVals=dimsizes(data)
 print(inputVals)

delim="-"
year=toint(str_get_field(data, 1, delim))
month=toint(str_get_field(data, 2, delim))
day=toint(str_get_field(data, 3, delim))


EU=new(inputVals,"double")

do d=0,inputVals-2




t1= doubletoint(cd_inv_calendar(year(d),month(d),day(d),12,00,00,time@units,0))
print(year(d))
print(day(d))
print(month(d))
z145E40N=infile1->z({t1},0,0)
z20E55N=infile2->z({t1},0,0)
z75E55N=infile3->z({t1},0,0)


EU(d)=-(1/4.0)*z20E55N+(1/2.0)*z75E55N-(1/4.0)*z145E40N

end do

print(EU)

asciiwrite("EU_WD1_LTE3North.txt",EU)










end
