#!/usr/bin/env python
import cdsapi
dateStart=['1997-12-01','1998-12-01','1999-12-01','2000-12-01','2001-12-01','2002-12-01','2003-12-01','2004-12-01','2005-12-01','2006-12-01','2007-12-01','2008-12-01','2009-12-01','2010-12-01','2011-12-01','2012-12-01','2013-12-01','2014-12-01','2015-12-01','2016-12-01','2017-12-01','2018-12-01']
datesEnd=['1997-12-31','1998-12-31','1999-12-31','2000-12-31','2001-12-31','2002-12-31','2003-12-31','2004-12-31','2005-12-31','2006-12-31','2007-12-31','2008-12-31','2009-12-31','2010-12-31','2011-12-31','2012-12-31','2013-12-31','2014-12-31','2015-12-31','2016-12-31','2017-12-31','2018-12-31']

#dateStart=['1997-01-01','1998-01-01','1999-01-01','2000-01-01','2001-01-01','2002-01-01','2003-01-01','2004-01-01','2005-01-01','2006-01-01','2007-01-01','2008-01-01','2009-01-01','2010-01-01','2011-01-01','2012-01-01','2013-01-01','2014-01-01','2015-01-01','2016-01-01','2017-01-01','2018-01-01']
#datesEnd=['1997-01-31','1998-01-31','1999-01-31','2000-01-31','2001-01-31','2002-01-31','2003-01-31','2004-01-31','2005-01-31','2006-01-31','2007-01-31','2008-01-31','2009-01-31','2010-01-31','2011-01-31','2012-01-31','2013-01-31','2014-01-31','2015-01-31','2016-01-31','2017-01-31','2018-01-31']
#dateStart=['2019-01-01']
#datesEnd=['2019-01-31']

c = cdsapi.Client()
for x,y in zip(dateStart,datesEnd):
 c.retrieve('reanalysis-era5-complete', {
     'class': 'ea',
#     'date':'2019-01-01/to/2019-01-31'
     'date': '%s/to/%s'%(x,y),
     'expver': '1',
     'levelist': '129/130/131/132/133/134/135/136/137',
     'levtype': 'ml',
     'grid': '0.25/0.25',
     'area': [40, 70, 15, 90], # North, West, South, East. Default: global
     'param': '129/130/131/132/133',
     'stream': 'oper',
     'time': '00:00:00/03:00:00/6/9/12:00:00/15:00:00/18/21',
     'type': 'an',
     'format':'netcdf' # Supported format: grib and netcdf. Default: grib
 }, 'ERA25_Temp_rh%sto%s.nc'%(x,y))
#  }, 'ERA25_Down2019-01-01to2019-01-31.nc'

