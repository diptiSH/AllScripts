begin

 f      = addfile ("ERA5NH_500_z_daily_NovDecJan.nc", "r")

 z=short2flt(f->z(:,{20:90},:))
 printVarSummary(z)


neof   = 10        ; number of EOFs
  optEOF = True       
  optEOF@jopt = 0   ; This is the default; most commonly used; no need to specify.
;;optEOF@jopt = 1   ; **only** if the correlation EOF is desired

  optETS = False


  xw     = z({latitude|:},{longitude|:},time|:)
  x      = z(time|:,{latitude|:},{longitude|:})

  eof      = eofunc_Wrap(xw, neof, optEOF)      
  eof_ts   = eofunc_ts_Wrap (xw, eof, optETS)

  printVarSummary( eof )                         ; examine EOF variables
  printVarSummary( eof_ts )



       system("/bin/rm -f AO.nc")   ; remove any pre-existing file
       ncdf = addfile("AO.nc" ,"c")  ; open output netCDF file
        ncdf->AO =  eof_ts(0,:)






end
