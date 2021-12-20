begin


do i=2013,2017

j=i+1

printState="cdo -b F32 -daymean -mergetime ERA5_z_t_u_v_Nov_"+i+"_0_12.nc ERA5_z_t_u_v_Dec_"+i+"_0_12.nc ERA5_z_t_u_v_Jan_"+j+"_0_12.nc ERA5_z_t_u_v_Feb_"+j+"_0_12.nc /home/cccr/rameshv/dipti/Data/ERA5_WaveData/daily_combFiles/ERA5_Daily_z_t_u_v_Nov_"+i+"toFeb"+j+".nc"

;print("cdo -b F32 -daymean -mergetime ERA5_z_t_u_v_Nov_"+i+"_0_12.nc ERA5_z_t_u_v_Dec_"+i+"_0_12.nc ERA5_z_t_u_v_Jan_"+j+"_0_12.nc ERA5_z_t_u_v_Feb_"+j+"_0_12.nc /home/cccr/rameshv/dipti/Data/ERA5_WaveData/daily_combFiles/ERA5_Daily_z_t_u_v_Nov_"i+"toFeb"+j+".nc")


print(printState)
end do
















end
