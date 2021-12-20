import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-pressure-levels',
    {
        'product_type': 'reanalysis',
        'variable': [
             'vertical_velocity',
        ],
        'pressure_level': '700',
        'year': [
             '2020',
             
        ],
        'month': [
            '01', 
        ],
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
        'time': [
            '00:00', '06:00',
            '12:00', 
            '18:00', 
        ],
        'format': 'netcdf',
        'area': '90/0/0/360',
	'grid': '2/2',
    },
    'ERA5NH_700_w_6hourly_Jan2020.nc')
