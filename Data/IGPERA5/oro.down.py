import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': 'orography',
        'year': [
            '1979', 
        ],
        'month': [
            '01', 
        ],
        'day': [
            '01', 
        ],
        'time': [
            '00:00',
        ],
        'format': 'netcdf',
        'area': [
            34, 70, 24,
            88,
        ],
    },
    'ERA5IGP_Orography.nc')
