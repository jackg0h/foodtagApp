#!flask/bin/python
import warnings
warnings.filterwarnings('ignore')
from keras.preprocessing import image
import pickle
import numpy as np
from scipy.misc import imread, imresize, imsave
from keras.optimizers import SGD

from flask import Flask
from flask import jsonify
from flask import abort
from flask import make_response
from flask import request
from flask import redirect
from flask import url_for
from flask import send_from_directory
from sklearn.externals import joblib
import matplotlib.pyplot as plt
from werkzeug import secure_filename
import cv2
import urllib2
import os
import time

from model import alexnet
from utils import preprocess_image, decode_label, preprocess_image_batch,load_data

app = Flask(__name__)
UPLOAD_FOLDER = './uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

picsList=[]

model = alexnet("alex_finetune567_aug_weights1.h5", nb_class=100)
clf = joblib.load('aug_finetune567.pkl')
#X_test = np.load(open('alex_bottleneck67_features_validation1.npy', 'rb'))

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1] in ALLOWED_EXTENSIONS

@app.route('/picture', methods=['GET', 'POST'])
def upload_file():
    if request.method == 'POST':
        file = request.files['file']
        if file:
            filename = str(time.time()).replace(".", "") + ".jpg"
            file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))

            img_path = os.path.join(app.config['UPLOAD_FOLDER'], filename)


            #im = preprocess_image_batch([img_path], img_size=(227,227),color_mode="rgb")
            #im = preprocess_image(img_path)
            im = imresize(imread(img_path), (227,227))

            im = im.transpose((2, 0, 1))
            im = np.expand_dims(im, axis=0)
            im = im.astype('float32')
            im /= 255

    
            deep_feature2 = model.predict(im)
            out = clf.predict_proba(deep_feature2)

            n = 5
            indices = np.argsort(out)[:,:-n-1:-1]

            print indices[0][0]

            return jsonify({'upload':True, 'name' : filename,
            'top1': {
                'label': str(decode_label(indices[0][0])),
                'proba': str(np.around(out[0][indices][0][0]*100,decimals=1))
            },
            'top2': {
                'label': str(decode_label(indices[0][1])),
                'proba': str(np.around(out[0][indices][0][1]*100,decimals=1))
            },
            'top3': {
                'label': str(decode_label(indices[0][2])),
                'proba': str(np.around(out[0][indices][0][2]*100,decimals=1))
            },
            'top4': {
                'label': str(decode_label(indices[0][3])),
                'proba': str(np.around(out[0][indices][0][3]*100,decimals=1))
            },
            'top5': {
                'label': str(decode_label(indices[0][4])),
                'proba': str(np.around(out[0][indices][0][4]*100,decimals=1))
            }
            })

    return '''
    <!doctype html>
    <title>Upload new File</title>
    <h1>Upload new File</h1>
    <form action="" method=post enctype=multipart/form-data>
      <p><input type=file name=file>
         <input type=submit value=Upload>
    </form>
    '''
@app.route('/get/picture/<string:name>', methods=['GET'])
def send_pics(name):
    pics = open("./files/" + name)
    if pics:
        return send_from_directory(app.config['UPLOAD_FOLDER'],
                                       name)

    abort(404)


@app.errorhandler(400)
def not_complete(error):
    return make_response(jsonify({'error' : 'request not complete'}), 400)

@app.errorhandler(404)
def not_found(error):
    return make_response(jsonify({'error': 'Not found'}), 404)

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
    p = path('./files')
    for f in p.files(pattern='*.jpg'):
        picsList.append({ 'url' : str('/show/pics/' + f.split('.')[0])})
