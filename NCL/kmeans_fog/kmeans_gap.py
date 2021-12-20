import numpy as np
import matplotlib.pyplot as plt

import netCDF4 as nc
from sklearn.metrics import pairwise_distances
from sklearn.cluster import KMeans


dataset = nc.Dataset('kmeansInput3.nc')
kmeansInput=dataset.variables['kmeansInput'][:]
print (dataset.variables.keys())
print(type(kmeansInput))
print(kmeansInput.shape)
print(len(kmeansInput))
X=kmeansInput

reference = np.random.rand(100, 2)


def compute_inertia(a, X):
    W = [np.mean(pairwise_distances(X[a == c, :])) for c in np.unique(a)]
    return np.mean(W)

def compute_gap(clustering, data, k_max=5, n_references=5):
    if len(data.shape) == 1:
        data = data.reshape(-1, 1)
    reference = np.random.rand(*data.shape)
    reference_inertia = []
    for k in range(1, k_max+1):
        local_inertia = []
        for _ in range(n_references):
            clustering.n_clusters = k
            assignments = clustering.fit_predict(reference)
            local_inertia.append(compute_inertia(assignments, reference))
        reference_inertia.append(np.mean(local_inertia))
    
    ondata_inertia = []
    for k in range(1, k_max+1):
        clustering.n_clusters = k
        assignments = clustering.fit_predict(data)
        ondata_inertia.append(compute_inertia(assignments, data))
        
    gap = np.log(reference_inertia)-np.log(ondata_inertia)
    return gap, np.log(reference_inertia), np.log(ondata_inertia)

k_max = 20
gap, reference_inertia, ondata_inertia = compute_gap(KMeans(), X, k_max)


#plt.plot(range(1, k_max+1), reference_inertia,
#         '-o', label='reference')
#plt.plot(range(1, k_max+1), ondata_inertia,
#         '-o', label='data')
#plt.xlabel('k')
#plt.ylabel('log(inertia)')
#plt.show()

plt.plot(range(1, k_max+1), gap, '-o')
plt.ylabel('gap')
plt.xlabel('k')
plt.savefig('foo_gap.png')
