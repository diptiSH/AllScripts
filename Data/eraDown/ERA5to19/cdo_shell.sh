#!/bin/bash
 # this is my first shell script.JGRJJD
        dates=(2004-01-13 
		2004-01-14 
		2004-01-15
		2004-01-16
		2004-01-17
		2016-12-11
		2016-12-12
		2016-12-13
		2016-12-14
		2014-12-20
		2014-12-21
		2014-12-22
		2014-12-23
		2014-12-24
		2015-01-21
		2015-01-22
		2015-01-23
		2003-01-23
		2003-01-24
		2003-01-25
		2011-12-16
		2011-12-17
		2011-12-18
		2011-12-19
		2011-12-20
		2017-01-04
		2017-01-05
		2017-01-06
		2017-01-07
		2018-01-02
		2018-01-03
		2018-01-04
		2018-01-05
		)
        #echo ${dates[*]}
       for i in "${dates[@]}"
       do
        echo $i
       
		cdo seldate,$i ERA5PerDay_.75_DecJan_1979_2019_uv200_download.nc "/home/cccr/rameshv/dipti/Data/eraDown/ERA5to19/GokulData/uv200/""$i""_200hPauv.nc"
		
          #echo item: $i
       done
