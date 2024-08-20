from flask import Flask, request, redirect, abort, send_file, jsonify
from redis import Redis, RedisError
from cassandra.cluster import Cluster
from cassandra.query import SimpleStatement

import os
import subprocess

app = Flask(__name__)

redis = Redis(host="redis-primary", db=0, socket_connect_timeout=2, socket_timeout=2)
cluster = Cluster(['10.128.1.45','10.128.2.45','10.128.3.45'])
session = cluster.connect('a2group99_keyspace')

WEB_ROOT = '.'

@app.route('/', methods=['GET'])
def home():
    try:
        return send_file(os.path.join(WEB_ROOT, 'index.html'))
    except FileNotFoundError:
        abort(404)

@app.route('/<short_url>', methods=['GET'])
def redirect_to_long(short_url):
    long_url = find(short_url)
    if long_url:
        return redirect(long_url, code=307)  
    else:
        abort(404)
        
@app.route('/', methods=['PUT'])
def record_redirect():
    short_url = request.args.get('short')
    long_url = request.args.get('long')
    if not short_url or not long_url:
        abort(400) 

    save(short_url, long_url)
    return send_file(os.path.join(WEB_ROOT, 'redirect_recorded.html'))

def find(short_url):

    # Check if in cache first
    long_url = redis.get(short_url)
    if long_url:
        return long_url.decode('utf-8')

    # Query from cassandra otherwise
    query = "SELECT long FROM urls WHERE short = %s"
    results = session.execute(query, [short_url])
    
    if results:
        row = results[0]
    else:
        return None
        
    redis_client.set(short_url, row.long, ex=1000)
    return row.long_url

def save(short_url, long_url):
    # Write to cassandra
    query = "INSERT INTO urls (short, long) VALUES (%s, %s)"
    session.execute(query, (short_url, long_url))

    # Update cache
    redis.set(short_url, long_url, ex=1000)

if __name__ == '__main__':
	app.run(host='0.0.0.0', port=8080)
