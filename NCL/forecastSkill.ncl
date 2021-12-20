begin

f=addfile("/home/cccr/rameshv/dipti/pySom/Data/InputstationVsDayt2mdds950s10aotinv1k.nc","r")

features=f->fetureinput

labels=f->labels

printVarSummary(features)
printVarSummary(labels)

a=0
b=0
c=0
d=0

do i=0,dimsizes(labels)-1

if(labels(i).eq.1.0)then
 
 if (features(i,1).le.1.5 )then
  
  a=a+1
 else
  c=c+1
 end if 

else
 if (features(i,1).le.1.5 )then
  b=b+1
 else
  d=d+1
 end if


end if

end do


print(a)
print(b)
print(c)
print(d)

FAR=b*1.0/(a+b)
POD=a*1.0/(a+c)
HSS=2.0*(a*d-b*c)/(((a+c)*(c+d))+((a+b*(b+d))))
TSS=(1.0*a*d-b*c)/((a+c)*(b+d))

print("FAR= "+FAR)
print("POD= "+POD)
print("HSS= "+HSS)
print("TSS= "+TSS)
end
