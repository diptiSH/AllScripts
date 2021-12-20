begin

;;;;;;;constants
omega= 0.000072921159 ;;;;;;;angular speed of Earth's rotation radians per SI second.  
a=6.37122e06  ;;;;;;;;mean radius of earth
;Rd= 287.058  ;;;; R for dry air = 287.058 J⋅kg−1⋅K−1
g0=9.080665     ;;;;;g0 = 9.80665 m/s and is called standard gravity.
R_by_cp=0.286   ;;;;;   R is the gas constant of air, and cp is the specific heat capacity at a constant pressure. R / c p = 0.286 for air (meteorology). R=8.314462 J⋅K−1⋅mol−1  cp=29.07 J⋅K−1⋅mol−1 


u200File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_DecJan_1979_2018_uv200_download.nc","r")
u700File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_uvrh700_download.nc","r")
t700File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_t700_download.nc","r")
t500File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_t500_download.nc","r")
t200File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_DecJan_1979_2018_t200_300_download.nc","r")
z200File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_DecJan_1979_2018_z200_300_download.nc","r")
z700File=addfile("/home/cccr/rameshv/dipti/Data/eraDown/ERA5PerDay_.75_decJan_1979_2018_z700_download.nc","r")


t500=short2flt(t500File->t)
t700=short2flt(t700File->t)
t200=short2flt(t200File->t(:,{200},:,:))
u200=short2flt(u200File->u)
u700=short2flt(u700File->u)
z700=short2flt(z700File->z)
z200=short2flt(z200File->z(:,{200},:,:))

;;;;;;;geopotential to geopotential ht
ht200=z200/g0
ht700=z700/g0

copy_VarMeta(z200,ht200)
copy_VarMeta(z700,ht700)


Latitude=t700&latitude

printVarSummary(Latitude)

;;;;;; Calculate f
f=coriolis_param(Latitude)
printVarSummary(f)

print(Latitude)
print(f)

d2r  = get_d2r("float" )
f_cal=new(dimsizes(Latitude),"float")
beta_cal=new(dimsizes(Latitude),"float")

do i=0,dimsizes(Latitude)-1

f_cal(i)=2*omega*sin(Latitude(i)*d2r)
beta_cal(i)=2*omega*cos(Latitude(i)*d2r)/a

end do

print(f_cal)

print(beta_cal)

;;;; calculate beta

;beta=beta_dfdy_rossby(Latitude, False)
;printVarSummary(beta)



;;;;;;;; calculate potential temperature
;,,,theta=T(P0/P)^^(R/cp)
theta500=t500*((1000.0/500.0)^R_by_cp)
theta200=t200*((1000.0/200.0)^R_by_cp)
theta700=t700*((1000.0/700.0)^R_by_cp)


;;;;;;;;;;;;calculate height

;Tavg=(t200+t500)/2.0

;;;Ht=Rd/(g0)*Tavg*log(p1/p2)

printVarSummary(ht200)
printVarSummary(ht700)
Ht=ht200-ht700

printVarSummary(Ht)

;;;;;;;;;;;;;;;;calculate instability index

BII=t700
printVarSummary(BII)

BII@standard_name="Baroclinic Instability"
BII@long_name="Baroclinic Instability calculated using Madhura et al 2015 paper"




do i=0,dimsizes(Latitude)-1

BII(:,i,:)=f_cal(i)*f_cal(i)*(u200(:,i,:)-u700(:,i,:))*theta500(:,i,:)/(beta_cal(i)*g0*Ht(:,i,:)*(theta200(:,i,:)-theta700(:,i,:)))

end do

printVarSummary(BII)

        system("/bin/rm -f BII.nc")   ; remove any pre-existing file
       ncdf = addfile("BII.nc" ,"c")  ; open output netCDF file
  ncdf->BII  = BII                          ; 3D       







end
