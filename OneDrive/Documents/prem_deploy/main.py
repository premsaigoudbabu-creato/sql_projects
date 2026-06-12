from flask import Flask, request, jsonify, send_from_directory
import pickle
import numpy as np

app = Flask(__name__)
model = pickle.load(open('model.pkl', 'rb'))

@app.route('/')
def home():
    return send_from_directory('.', 'index.html')

@app.route('/predict', methods=['POST'])
def predict():
    data = request.json['features']
    prediction = model.predict([data])
    return jsonify({'prediction': round(float(prediction[0]), 2)})

if __name__ == '__main__':
    app.run(debug=True)

@app.route('/')
def home():
    return send_from_directory('.', 'index.html')