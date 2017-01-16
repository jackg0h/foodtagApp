
import numpy as np
import cv2
from scipy.misc import imread, imresize, imsave
'''
im = imresize(imread('uploads/14845633117.jpg'), (227,227))
r = im[:,:,0].flatten() #Slicing to get R data
g = im[:,:,1].flatten() #Slicing to get G data
b = im[:,:,2].flatten() #Slicing to get B data
new_array = np.array([[r] + [g] + [b]], np.uint8)
data = new_array.reshape(new_array .shape[0], 3, 227, 227)
print data.shape
#im = im.transpose((2, 0, 1))
#print im.shape
'''


import numpy as np
import matplotlib.pyplot as plt
from six.moves import cPickle

X = np.load(open('alex_bottleneck67_features_validation1.npy', 'rb'))
X = X.reshape(10000, 3, 32, 32).transpose(0,2,3,1).astype("float")
Y = np.array(Y)

#Visualizing CIFAR 10
fig, axes1 = plt.subplots(5,5,figsize=(3,3))
for j in range(5):
    for k in range(5):
        i = np.random.choice(range(len(X)))
        axes1[j][k].set_axis_off()
        axes1[j][k].imshow(X[i:i+1][0])
