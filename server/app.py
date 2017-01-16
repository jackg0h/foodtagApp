#!flask/bin/python
import warnings
warnings.filterwarnings('ignore')
from keras.preprocessing import image
import numpy as np

from flask import Flask
from flask import jsonify
from flask import abort
from flask import make_response
from flask import request
from flask import redirect
from flask import url_for
from flask import send_from_directory
from werkzeug import secure_filename
import urllib2
import os
import time

from model import alexnet
from utils import preprocess_image

app = Flask(__name__)
UPLOAD_FOLDER = './uploads'
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

picsList=[]


model = alexnet("alex_finetune567_aug_weights.h5", nb_class=100)


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
            img = image.load_img(img_path, target_size=(227, 227))
            im = preprocess_image(img)
            out = model.predict(im)
            n = 5
            indices = np.argsort(out)[:,:-n-1:-1]

            top1 = np.argmax(out)
            return jsonify({'upload':True, 'name' : filename, 'prediction': {
            'top1': str(indices[0][0]),
            'proba': str(round(out[0][indices][0][0], 0))
            },
            'top2': str(indices[0][1]),
            'top3': str(indices[0][2]),
            'top4': str(indices[0][3]),
            'top5': str(indices[0][4]),
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
