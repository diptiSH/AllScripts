import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'variable': 'orography',
        'year': '1979',
        'month': '01',
        'day': '01',
        'time': '00:00',
        'grid': '0.75/.75',
        'area'    : '90/0/0/360', # North, West, South, East. Default: global
    },
    'topography.nc')
