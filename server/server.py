#!/usr/bin/env python
# -*- coding: utf-8 -*-
import os
import sys
from bottle import Bottle, view, run,\
    static_file, request
import simplejson

app = Bottle()
response = file('thread.json').read()

@app.route('/thread.json')
def about(): return response

@app.route('/src/:fname#.*#')
def static(fname): return static_file(fname, root="src/")

if __name__ == '__main__':
    run(app, host='localhost', port=8080, reloader=True)