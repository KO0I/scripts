from gnuradio import gr
from scipy.io import loadmat

variablelist = loadmat('/home/amber/downloads/corruptedsong.mat')
var1 = variablelist['var1name'].tolist()
