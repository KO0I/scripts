import numpy as np
import h5py
f = h5py.File('/home/patrick/downloads/corruptedsong.mat','r')
zz =f['a'].value.view(np.double).reshape((10,10,10,2))
zzj = zz[:,:,:,0]+ 1j*zz[:,:,:,1]
zzk = f['a'].value.view(np.complex)
np.all(zzk == zzj)  # result is "True"
zzj.shape  # result is (10, 10, 10)
zzk[9,9,9].imag == f['a'][9,9,9][1]  # result is "True"
zzk[9,9,9]
