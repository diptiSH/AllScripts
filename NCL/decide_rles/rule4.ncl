begin

noVars=5

f=addfile("/home/cccr/rameshv/dipti/pySom/random_forest_WSF/Data/input_nc/input_era_fog_dd_rh950_fsi_coolRate_crossT_1998_2016.nc","r")
;f=addfile("/home/cccr/rameshv/dipti/pySom/random_forest_WSF/Data/input_nc/input_era_fog_dd_fsi_vars_rh950_1998_2016.nc","r")

features=f->fetureinput

labels=f->labels

printVarSummary(features)
printVarSummary(labels)

cntF=0
cntN=0
do i=0,dimsizes(labels)-1

if(features(i,0).lt.4.2  .and. features(i,4).lt.5.7)then

if(labels(i).eq.1) then
cntF=cntF+1
else
cntN=cntN+1
end if

end if

end do

print(cntF)
print(cntN)


featureValsF=new((/cntF,noVars/),float)
featureValsN=new((/cntN,noVars/),float)

;featureValsF=new((/cntF,6/),float)
;featureValsN=new((/cntN,6/),float)

iF=0
iN=0
do i=0,dimsizes(labels)-1

if(features(i,0).lt.4.2 .and. features(i,4).lt.5.7 )then

if(labels(i).eq.1) then
featureValsF(iF,:)=features(i,:)
iF=iF+1
else
featureValsN(iN,:)=features(i,:)
iN=iN+1
end if

end if
end do


x25F  = round(.1*cntF,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.9*cntF,3)-1     ; at 0


x25N  = round(.1*cntN,3)-1     ; -1 to account for NCL indexing starting
x75N  = round(.9*cntN,3)-1     ; at 0

iarrF=new((/noVars,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series

iarrN=new((/noVars,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series


do i=0,noVars-1

qsort(featureValsF(:,i))
qsort(featureValsN(:,i))

tsF=featureValsF(:,i)
;if(i.gt.3 .and. i.lt.8)then
;tsF=tsF*10000
;end if

;iarrF(i,:) = (/min(featureValsF(:,i)),featureValsF(:,i)(x25F),dim_median(featureValsF(:,i)),featureValsF(:,i)(x75F),max(featureValsF(:,i))/)

iarrF(i,:) = (/min(tsF),tsF(x25F),dim_median(tsF),tsF(x75F),max(tsF)/)

tsN=featureValsN(:,i)
;iarrN(i,:) = (/min(featureValsN(:,i)),featureValsN(:,i)(x25N),dim_median(featureValsN(:,i)),featureValsN(:,i)(x75N),max(featureValsN(:,i))/)
;if(i.gt.3 .and. i.lt.8)then
;tsN=tsN*10000
;end if

iarrN(i,:) = (/min(tsN),tsN(x25N),dim_median(tsN),tsN(x75N),max(tsN)/)
end do

print(iarrF)
print(iarrN)

wks = gsn_open_wks("png","95_dd3_rh950_u950_crossover530_shProfile_1998_2016")               ; send graphics to PNG file
  plot=new(noVars,graphic)
  res            = True                         ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False
 res@tmXBLabels = (/"Fog","No Fog"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True


do i=0,noVars-1
  res@tiMainString = i+1
  res@gsnLeftString=i
  opti@boxColors = (/"blue","red"/)
  plot(i)=boxplot(wks,(/0,1/),(/iarrF(i,:),iarrN(i,:)/),opti,res,False)
  end do
;  plot = boxplot(wks,(/0,1,2,3,4,5/),iarrF,False,res,False)
;  plot2 = boxplot(wks,(/0,1,2,3,4,5/),iarrN,False,res,False)
;************************************************
; create panel
;************************************************
  gsn_panel(wks,plot,(/2,3/),False)             ; now draw as one plot

draw(wks)                                    ; boxplot does not call these
  frame(wks)

end

