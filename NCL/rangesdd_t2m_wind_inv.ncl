begin
Title=(/"DD","T2m","10 m wind","Inversion"/)
f=addfile("/home/cccr/rameshv/dipti/pySom/Data/InputstationVsDayt2mdds950s10aotinv1k.nc","r")

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


featureValsF=new((/cntF,4/),float)
featureValsN=new((/cntN,4/),float)

iF=0
iN=0
do i=0,dimsizes(labels)-1

if(labels(i).eq.1)then

featureValsF(iF,0)=features(i,1)
featureValsF(iF,1)=features(i,0)
featureValsF(iF,2)=features(i,3)
featureValsF(iF,3)=features(i,5)

iF=iF+1
else
featureValsN(iN,0)=features(i,1)
featureValsN(iN,1)=features(i,0)
featureValsN(iN,2)=features(i,3)
featureValsN(iN,3)=features(i,5)

iN=iN+1
end if
end do


x25F  = round(.25*cntF,3)-1     ; -1 to account for NCL indexing starting
x75F  = round(.75*cntF,3)-1     ; at 0 


x25N  = round(.25*cntN,3)-1     ; -1 to account for NCL indexing starting
x75N  = round(.75*cntN,3)-1     ; at 0

iarrF=new((/4,5/),float) ; fill with minimum, 25th percentile, median, 
                          ; 75th percentile, maximum of each time series

iarrN=new((/4,5/),float) ; fill with minimum, 25th percentile, median,
                          ; 75th percentile, maximum of each time series


do i=0,3

qsort(featureValsF(:,i))
qsort(featureValsN(:,i))

tsF=featureValsF(:,i)

;iarrF(i,:) = (/min(featureValsF(:,i)),featureValsF(:,i)(x25F),dim_median(featureValsF(:,i)),featureValsF(:,i)(x75F),max(featureValsF(:,i))/) 

iarrF(i,:) = (/min(tsF),tsF(x25F),dim_median(tsF),tsF(x75F),max(tsF)/)

tsN=featureValsN(:,i)
;iarrN(i,:) = (/min(featureValsN(:,i)),featureValsN(:,i)(x25N),dim_median(featureValsN(:,i)),featureValsN(:,i)(x75N),max(featureValsN(:,i))/)

iarrN(i,:) = (/min(tsN),tsN(x25N),dim_median(tsN),tsN(x75N),max(tsN)/)
end do

wks = gsn_open_wks("png","Newbox")               ; send graphics to PNG file
  plot=new(4,graphic)
  res            = True                         ; plot mods desired
  res@gsnDraw   = False
  res@gsnFrame  = False  
 res@tmXBLabels = (/"Fog","No Fog"/) ; labels for each box
  ; res@tiMainString = "Box Plot"
  ; res@trYMinF = 230.
 ; res@trYMaxF = 345.
 opti=True  
print(iarrF)
print(iarrN)  
do i=0,3
  res@tiMainString =Title(i)
  opti@boxColors = (/"blue","red"/)
  plot(i)=boxplot(wks,(/0,1/),(/iarrF(i,:),iarrN(i,:)/),opti,res,False)
  end do
;  plot = boxplot(wks,(/0,1,2,3,4,5/),iarrF,False,res,False)
;  plot2 = boxplot(wks,(/0,1,2,3,4,5/),iarrN,False,res,False)
;************************************************
; create panel
;************************************************
  gsn_panel(wks,plot,(/2,2/),False)             ; now draw as one plot

draw(wks)                                    ; boxplot does not call these
  frame(wks) 

end