import cdsapi

c = cdsapi.Client()

c.retrieve(
    'reanalysis-era5-pressure-levels',
    {
        'product_type': 'reanalysis',
        'format': 'netcdf',
        'time': [
           '03:00',

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
            '1', '12', 
        ],
         'year': [
            '1979', '1980', '1981',
            '1982', '1983', '1984',
            '1985', '1986', '1987',
            '1988', '1989', '1990',
            '1991', '1992', '1993',
            '1994', '1995', '1996',
            '1997', '1998', '1999',
            '2000', '2001', '2002',
            '2003', '2004', '2005',
            '2006', '2007', '2008',
            '2009', '2010', '2011',
            '2012', '2013', '2014',
            '2015', '2016', '2017',
            '2018','2019',
        ],
        'pressure_level': ['900',],
        'area'    : '90/0/0/360', # North, West, South, East. Default: global
        'variable':[ 
                     'geopotential', 'relative_humidity','temperature', 'u_component_of_wind',
            'v_component_of_wind', 'vertical_velocity',],
    },
    'ERA5_.75_3UTC_DecJan_1979_2019_ztuvrw_900.nc')
