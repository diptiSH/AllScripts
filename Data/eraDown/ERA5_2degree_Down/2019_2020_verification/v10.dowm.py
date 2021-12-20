import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-single-levels',
    {
        'product_type': 'reanalysis',
        'variable': '10m_v_component_of_wind',
        'year': [
             '2020',
            
        ],
        'month': [
            '01'
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
            '28', '29', '30','31',
        ],
        'time': [
            '00:00',  '06:00',
            '12:00', 
            '18:00', 
        ],
	'grid': '2/2',
        'format': 'netcdf',
        'area': '90/0/0/360',
    },
    'ERA5NH_v10_6hourly_Jan2020.nc')
