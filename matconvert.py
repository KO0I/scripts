from gnuradio import gr
from scipy.io import loadmat

variablelist = loadmat('/home/patrick/downloads/corruptedsong.mat')
var1 = variablelist['var1name'].tolist()
