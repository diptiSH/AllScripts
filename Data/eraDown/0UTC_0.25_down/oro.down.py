import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': 'Geopotential',
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
            '00',
        ],

        'grid': '0.75/.75',
        'format': 'netcdf',
        'area': '90/0/0/360',

    },
    'ERA5IGP_Orography.nc')

