from flask import Flask
app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

if __name__ == '__main__':
    # Use 0.0.0.0 to make it accessible outside the container
    app.run(debug=True, host='0.0.0.0')