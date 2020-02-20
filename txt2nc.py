import numpy as np
import time
from netCDF4 import Dataset

data = np.loadtxt('pre_annual.txt') # data是一个二维数组

output_name = 'CRU.nc'
units = 'mm'
long_name = 'Annual Rain CRU'

col = 720
row = 360


dataset = Dataset(output_name, 'w', format = 'NETCDF4_CLASSIC')

lat = dataset.createDimension('lat', row)

lon = dataset.createDimension('lon', col)

latitudes = dataset.createVariable('latitude', np.float32, ('lat',))

longitudes = dataset.createVariable('longitude', np.float32, ('lon',))

temp = dataset.createVariable('temp', np.float32, ('lat', 'lon'))

dataset.description = 'example script'

dataset.history = 'Created ' + time.ctime(time.time())

dataset.source = 'netCDF4 python module tutorial'

latitudes.units = 'degree_north'

longitudes.units = 'degree_east'

temp.units = units

temp.long_name = long_name

latitudes[:] = np.arange(89.75, -90.25, -0.5)

longitudes[:] = np.arange(-179.75, 180.25, 0.5)

temp[:, :] = data

dataset.close()
