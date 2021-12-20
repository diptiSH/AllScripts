import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-complete',
    {
#        'product_type': 'reanalysis',
        'format': 'netcdf',
#        'variable': [
#             '2m_dewpoint_temperature',
#            '2m_temperature'
#        ],
        'class': 'ea',
        'levtype': 'ml',
        'stream': 'oper',
        'type': 'an',
        'levelist': '133',
        'param': '130/131/132',
 7', '2008',
            '2009', '2010', '2011',
            '2012', '2013', '2014',
            '2015', '2016', '2017',
            '2018', 
        ],
        'month': [
            '01', '12',
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
        'grid': '0.75/.75',
        'area'    : '90/0/0/360', # North, West, South, East. Default: global
        
        'time': [
            '03:00',
        ],
    },
    'ERA5_.75_decJan_1979_2018_100m_t_uv_3_download.nc')
