begin
f=addfile("/home/cccr/rameshv/dipti/Data/ERA5/ERA5files/ER5_500hPa_pl_DecJan_1979-2019_0_Down.nc","r")
z=short2flt(f->z)
printVarSummary(z)
nlat=dimsizes(z(0,:,0))

;exit
;;;;;;; Convert to appropriate units
z500=z/9.81

copy_VarMeta(z,z500)

units=z500&time@units
;;;;;;;;; read Dates to make composites

;print(Dates)

data=asciiread("/home/cccr/rameshv/dipti/NCL/GetWidespreadFogDays/WSFogDays_1.5ddCriteria50Per_mt20.csv",-1,"string")
delim=","
Dates=str_get_field(data, 1, delim)
delim="-"
day=toint(str_get_field(Dates, 1, delim))
month=toint(str_get_field(Dates, 2, delim))
year=toint(str_get_field(Dates, 3, delim))

 print(Dates)
;;;;;;;;; Define variables to hold values before making composites
testz500=new((/dimsizes(Dates),dimsizes(z500(0,:,0)),dimsizes(z500(0,0,:))/),typeof(z500))

;;;;;;;;;;;;;;;;; get data on given days

do i=0,dimsizes(Dates)-1
   ;    print(i)
        JTime=cd_inv_calendar(year(i),month(i),day(i),00,00,00,units,0)
    ;   print(JTime)
    ;   print(year(i))
     ;  print(month(i))
     ;  print(day(i))
       do k=0,nlat-1
        testz500(i,k,:)=z500({JTime},k,:)-dim_avg_n_Wrap(z500({JTime},k,:),0)
       end do

end do

;;;;;;;;; Average over time to get composite values
comp_z500=dim_avg_n_Wrap(testz500,0)
printVarSummary(comp_z500)
copy_VarMeta(z(0,:,:),comp_z500)


printVarSummary(comp_z500)

;;;;;;;;;;;;;;;plotting

wks = gsn_open_wks("png","stationary_pattern_mt20")         ; send graphics to PNG file

res = True
res@mpFillOn = False
  res@mpCenterLonF = 80
  res@mpOutlineOn = True 
res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels with the following 3 resources
  res@cnMinLevelValF  = -200.			; set the minimum contour level
  res@cnMaxLevelValF  = 200.			; set the maximum contour level
  res@cnLevelSpacingF = 40.			; set the interval between contou
res@gsnPolar   = "NH"
res@cnFillOn        = True                    ; turn on color 
 res@cnFillPalette   = "BlueRed";"BlRe";"gui_default"           ; set color map
plot1 = gsn_csm_contour_map(wks,comp_z500,res)    ; create and draw the temperature plot



end
