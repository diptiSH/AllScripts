import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-pressure-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'time': [
            '00:00', '06:00', '12:00',
            '18:00',
        ],
        
        'grid': '0.75/.75',
        'day': [
            '01', '02', '03',
            '04', '05', '06',
            '07', '08', '09',
            '10', '11', '12',
            '13', '14', '15',
            '16', '17', '18',
            '19', '20', '21',
            '22', '23', '24',
            '25', '26', '27',
            '28', '29', '30',
            '31',
        ],
        'month': [
            '01', '12',
        ],
         'year': [
            '2019', 
        ],
        'pressure_level': [ '500','700','300','950'],
        'area'    : '90/0/0/360', # North, West, South, East. Default: global
        'variable': ['geopotential','relative_humidity', 'specific_humidity', 'u_component_of_wind',
            'v_component_of_wind','temperature',],
    },
    'ERA5_.75_decJan_2019_download.nc')
