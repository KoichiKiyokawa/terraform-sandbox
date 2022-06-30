#!/usr/bin/env python
# -*- coding: utf-8 -*-


import random
import raytrace

from flask import Flask, make_response
import tempfile


app = Flask(__name__)


@app.route('/render', methods=['GET'], strict_slashes=False)
def render():
    temp = tempfile.TemporaryDirectory()

    path = temp.name + '/image.png'
    index = [0, 1, 2, 3]
    random.shuffle(index)
    raytrace.render(path, index)
    f = open(path, 'rb')
    data = f.read()
    f.close()

    temp.cleanup()

    response = make_response(data)
    response.headers.set('Content-Type', 'image/png')
    return response


@app.route('/', methods=['GET'], strict_slashes=False)
def index():
    return 'success v3'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')
