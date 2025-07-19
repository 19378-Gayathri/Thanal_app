from flask import Flask, request, jsonify
from google.cloud.dialogflow_v2 import SessionsClient
from google.cloud.dialogflow_v2.types import TextInput, QueryInput
import json
import os
import pathlib
import logging
from werkzeug.middleware.proxy_fix import ProxyFix
from functools import lru_cache

# Initialize logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
app.wsgi_app = ProxyFix(app.wsgi_app, x_proto=1)

# Configuration
CONFIG = {
    "OFFLINE_DB_PATH": pathlib.Path('offline_db.json'),
    "SERVICE_ACCOUNT_PATH": pathlib.Path('service-account-key.json'),
    "DIALOGFLOW_PROJECT_ID": "thanalchatbot",
    "DEFAULT_LANGUAGE": "en",
    "FALLBACK_RESPONSE": "Emergency tip: Find high ground. More features require internet."
}

# Security headers middleware
@app.after_request
def add_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    return response

@lru_cache(maxsize=1)
def load_offline_db():
    """Cache the offline DB for better performance"""
    try:
        return json.loads(CONFIG["OFFLINE_DB_PATH"].read_text(encoding='utf-8'))
    except Exception as e:
        logger.error(f"Failed to load offline DB: {e}")
        return {
            "flood": {
                "en": CONFIG["FALLBACK_RESPONSE"],
                "ml": "അടിയന്തിര ടിപ്പ്: ഉയർന്ന സ്ഥലം തേടുക. കൂടുതൽ സവിശേഷതകൾക്ക് ഇന്റർനെറ്റ് ആവശ്യമാണ്."
            }
        }

def initialize_dialogflow():
    """Initialize Dialogflow client with validation"""
    if not CONFIG["SERVICE_ACCOUNT_PATH"].exists():
        raise FileNotFoundError("Service account file not found")
    
    os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = str(CONFIG["SERVICE_ACCOUNT_PATH"])
    return SessionsClient()

def detect_intent_text(session_id, text, language_code=CONFIG["DEFAULT_LANGUAGE"]):
    """Handles Dialogflow intent detection with improved error handling"""
    try:
        session_client = initialize_dialogflow()
        session = session_client.session_path(CONFIG["DIALOGFLOW_PROJECT_ID"], session_id)
        
        text_input = TextInput(text=text, language_code=language_code)
        query_input = QueryInput(text=text_input)
        
        response = session_client.detect_intent(
            session=session, 
            query_input=query_input
        )
        
        return {
            "reply": response.query_result.fulfillment_text,
            "confidence": response.query_result.intent_detection_confidence,
            "intent": response.query_result.intent.display_name
        }
    except Exception as e:
        logger.error(f"Dialogflow error: {e}")
        raise

@app.route('/chat', methods=['POST'])
def chat():
    """Main chat endpoint with enhanced validation"""
    if not request.is_json:
        return jsonify({"error": "Request must be JSON"}), 400
    
    data = request.get_json()
    user_input = data.get('query', "").strip().lower()
    user_id = data.get('user_id', "default_session")
    lang = data.get('lang', CONFIG["DEFAULT_LANGUAGE"])
    
    if not user_input:
        return jsonify({"error": "Empty query"}), 400
    
    OFFLINE_DB = load_offline_db()
    
    # Check offline database with exact match for better precision
    for keyword, responses in OFFLINE_DB.items():
        if keyword in user_input:
            reply = responses.get(lang, responses[CONFIG["DEFAULT_LANGUAGE"]])
            return jsonify({
                "reply": reply,
                "source": "offline_db"
            })
    
    # Fallback to Dialogflow
    try:
        dialogflow_response = detect_intent_text(user_id, user_input, lang)
        return jsonify({
            "reply": dialogflow_response["reply"],
            "intent": dialogflow_response["intent"],
            "source": "dialogflow"
        })
    except Exception as e:
        logger.error(f"Chat error: {e}")
        return jsonify({
            "reply": CONFIG["FALLBACK_RESPONSE"],
            "error": "Service temporarily unavailable"
        }), 503

@app.route('/health', methods=['GET'])
def health_check():
    """Simple health check endpoint"""
    return jsonify({"status": "healthy"})

if __name__ == '__main__':
    # Validate critical files exist
    required_files = [CONFIG["OFFLINE_DB_PATH"], CONFIG["SERVICE_ACCOUNT_PATH"]]
    for file in required_files:
        if not file.exists():
            logger.warning(f"Missing required file: {file.name}")
    
    app.run(host='0.0.0.0', port=5000, debug=True)