import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': [
            'orography',
        ],
        'year': [
            '1979', 
      
        ],
        'month': [
            '1', 
        ],
        'day': [
            '01', 
        ],
     
        'area'    : '35/70/20/90', # North, West, South, East. Default: global
        'time': [
            '00:00', 
        ],
    },
    'ERA5_Oro.nc')
