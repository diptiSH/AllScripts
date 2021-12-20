begin

f=addfile("/home/cccr/rameshv/dipti/pySom/random_forest_WSF/Data/input_nc//input_era_fog_dd_rh950_u950_crossover530_1998_2016.nc","r")

features=f->fetureinput

labels=f->labels

printVarSummary(features)
printVarSummary(labels)

cntF=0
cntN=0

NOF=0
FAR=0

do i=0,dimsizes(labels)-1

if(labels(i).eq.1 )then
cntN=cntN+1

;if(features(i,0).lt.3.5 .and. features(i,1).lt.3.0 .and.  features(i,13).gt.52 .and. features(i,14).lt.6.5 .and. features(i,17).lt.0.0 ) then
;if(features(i,0).lt.3.5 .and. features(i,1).gt.52 .and. features(i,2).gt.-3.0 .and. features(i,3).le.3.25) then
;if(features(i,0).lt.3.5 .and. features(i,17).lt.0.0 ) then
;if(features(i,0).lt.3.5 .and. features(i,14).lt.6.5 ) then
;if(features(i,0).lt.3.5 .and. features(i,4).lt.15 ) then
;if(features(i,0).lt.3.5 .and. features(i,1).gt.52  .and. features(i,3).le.3.25 ) then
if(features(i,0).lt.3.5 .and. features(i,3).le.3.25 ) then



cntF=cntF+1
end if


else

NOF=NOF+1
;if(features(i,0).lt.3.5 .and. features(i,1).lt.3.0 .and.  features(i,13).gt.52 .and. features(i,14).lt.6.5 .and. features(i,17).lt.0.0 ) then

;if(features(i,0).lt.3.5 .and. features(i,1).lt.3.0 .and. features(i,4).lt.15  ) then
;if(features(i,0).lt.3.5 ) then
;if(features(i,0).lt.3.5 .and. features(i,1).gt.52 .and. features(i,2).gt.-3.0 .and. features(i,3).le.3.25 ) then
;if(features(i,0).lt.3.5 .and. features(i,17).lt.0.0 ) then
;if(features(i,0).lt.3.5 .and. features(i,14).lt.6.5 ) then
;if(features(i,0).lt.3.5 .and. features(i,4).lt.15 ) then
;if(features(i,0).lt.3.5 .and. features(i,1).gt.52  .and. features(i,3).le.3.25 ) then
if(features(i,0).lt.3.5 .and. features(i,3).le.3.25 ) then



FAR=FAR+1
end if

;if(features(i,0).lt.3.5) then
;cntN=cntN+1
;end if
end if

end do

print(cntF)
print(cntN)

print(NOF)
print(FAR)

print("Hit Rate")
print(1.0*cntF/cntN)

print("FAR")
print(1.0*FAR/NOF)

exit


end
