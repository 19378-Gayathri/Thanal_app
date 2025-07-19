from flask import Flask, request, jsonify

app = Flask(__name__)

@app.route('/chat', methods=['POST'])
def chat():
    data = request.get_json()
    query = data.get('query', '')
    lang = data.get('lang', 'en')
    
    # Example dummy reply
    reply = f"You said: {query} (Lang: {lang})"
    
    return jsonify({'reply': reply})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
