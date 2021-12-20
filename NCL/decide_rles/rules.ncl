begin

f=addfile("/home/cccr/rameshv/dipti/pySom/random_forest_WSF/Data/input_nc/input_era_fog_dd_w10_tskin530_tskin830_fsi_VC_t2m_aot_VC100_BLHt_BLHt_lastDay_w100_z500_1998_2016.nc","r")

features=f->fetureinput

labels=f->labels

printVarSummary(features)
printVarSummary(labels)

cntF=0
cntN=0
do i=0,dimsizes(labels)-1

if(labels(i).eq.1)then
cntF=cntF+1
else
cntN=cntN+1
end if

end do

print(cntF)
print(cntN)


featureValsF=new((/cntF,13/),float)
featureValsN=new((/cntN,13/),float)

iF=0
iN=0
do i=0,dimsizes(labels)-1

if(labels(i).eq.1)then
featureValsF(iF,:)=features(i,:)
iF=iF+1
else
featureValsN(iN,:)=features(i,:)
iN=iN+1
end if
end do


x25F  = round(.05*cntF,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.95*cntF,3)-1     ; at 0


x25N  = round(.05*cntN,3)-1     ; -1 to account for NCL indexing starting
x75N  = round(.95*cntN,3)-1     ; at 0

iarrF=new((/13,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

iarrN=new((/13,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series


do i=0,12

qsort(featureValsF(:,i))
qsort(featureValsN(:,i))

tsF=featureValsF(:,i)
;iarrF(i,:) = (/min(featureValsF(:,i)),featureValsF(:,i)(x25F),dim_median(featureValsF(:,i)),featureValsF(:,i)(x75F),max(featureValsF(:,i))/)

iarrF(i,:) = (/min(tsF),tsF(x25F),dim_median(tsF),tsF(x75F),max(tsF)/)

tsN=featureValsN(:,i)
;iarrN(i,:) = (/min(featureValsN(:,i)),featureValsN(:,i)(x25N),dim_median(featureValsN(:,i)),featureValsN(:,i)(x75N),max(featureValsN(:,i))/)

iarrN(i,:) = (/min(tsN),tsN(x25N),dim_median(tsN),tsN(x75N),max(tsN)/)
end do

print(iarrF)
print(iarrN)

end
