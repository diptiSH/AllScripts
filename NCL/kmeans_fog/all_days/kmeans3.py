
from sklearn.cluster import KMeans 
from sklearn import metrics 
from scipy.spatial.distance import cdist 
import numpy as np 
import matplotlib.pyplot as plt 
import netCDF4 as nc
import matplotlib.cm as cm
from sklearn.decomposition import PCA


print("okkkkkkk")

#read input data
#dataset = nc.Dataset('/home/cccr/rameshv/dipti/Data/WDF_RF_Dayst2m.nc')
dataset = nc.Dataset('kmeansInput_slp_allDays.nc')
kmeansInput=dataset.variables['kmeansInput'][:]
print (dataset.variables.keys())
print(type(kmeansInput))
print(kmeansInput.shape)
print(len(kmeansInput))
X=kmeansInput



pca = PCA(n_components=10, svd_solver='full')
pca.fit(X)
print(pca.explained_variance_ratio_)



distortions = [] 
inertias = [] 
mapping1 = {} 
mapping2 = {} 
K = range(1,100) 
  
for k in K: 
    #Building and fitting the model 
    kmeanModel = KMeans(n_clusters=k).fit(X) 
    kmeanModel.fit(X)     
      
    distortions.append(sum(np.min(cdist(X, kmeanModel.cluster_centers_, 
                      'euclidean'),axis=1)) / X.shape[0]) 
    inertias.append(kmeanModel.inertia_) 
  
    mapping1[k] = sum(np.min(cdist(X, kmeanModel.cluster_centers_, 
                 'euclidean'),axis=1)) / X.shape[0] 
    mapping2[k] = kmeanModel.inertia_ 

for key,val in mapping1.items(): 
    print(str(key)+' : '+str(val)) 


#plt.plot(K, distortions, 'bx-') 
#plt.xlabel('Values of K') 
#plt.ylabel('Distortion') 
#plt.title('The Elbow Method using Distortion') 
#plt.show() 
#plt.savefig('foo.png')


for key,val in mapping2.items(): 
    print(str(key)+' : '+str(val)) 
plt.plot(K, inertias, 'bx-') 
plt.xlabel('Values of K') 
plt.ylabel('Inertia') 
plt.title('The Elbow Method using Inertia') 
plt.savefig('foo2.png')
