from flask import Flask
from os import getenv
import zmq

app = Flask(__name__)
zmq_context = zmq.Context()

@app.route('/', methods=['GET'])
def index():
  with zmq_context.socket(zmq.PUSH) as socket:
    socket.connect(getenv('WORKER_URL'))
    socket.send(b"hello")
  return 'console'

if __name__ == '__main__':
  app.run(host='0.0.0.0', port=getenv('SERVICE_PORT', 80))
