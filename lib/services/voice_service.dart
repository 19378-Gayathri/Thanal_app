import 'package:flutter/services.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:easy_localization/easy_localization.dart';

class VoiceService { 
  final SpeechToText _speech = SpeechToText();
  final FlutterTts _tts = FlutterTts();
  late DialogflowGrpcV2Beta1 _dialogflow;

  Future<bool> init() async {
    await _tts.setSpeechRate(0.5);
    return await _speech.initialize();
  }

  Future<void> initDialogflow() async {
    final serviceAccount = ServiceAccount.fromString(
      await rootBundle.loadString('assets/dialogflow_key.json'),
    );
    _dialogflow = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);
  }

  Future<String> processDisasterCommand(String query, String locale) async {
    try {
      final response = await _dialogflow.detectIntent(query, locale);
      
      final params = response.queryResult.parameters.fields;
      if (params['disaster_type'] != null) {
        return _generateDisasterResponse(
          params['disaster_type']?.stringValue,
          params['location']?.stringValue ?? '',
          locale
        );
      }
      return response.queryResult.fulfillmentText;
    } catch (e) {
      print('Dialogflow Error: $e');
      return tr('voice_processing_error'); // Make sure this key exists in your translations
    }
  }

  String _generateDisasterResponse(String? disasterType, String location, String locale) {
    final locationPhrase = location.isNotEmpty 
        ? locale == 'ml' ? ' $location-ൽ' : ' in $location'
        : '';
        
    switch (disasterType) {
      case 'flood':
        return locale == 'ml' 
            ? 'വെള്ളപ്പൊക്ക എച്ചരിക്കുന്നു$locationPhrase! സഹായം വരുന്നു'
            : 'Flood alert$locationPhrase! Help is coming';
      case 'earthquake':
        return locale == 'ml'
            ? 'ഭൂകമ്പം കണ്ടെത്തി$locationPhrase! സുരക്ഷിതമായ സ്ഥലത്തേക്ക് നീങ്ങുക'
            : 'Earthquake detected$locationPhrase! Move to safety';
      case 'landslide':
        return locale == 'ml'
            ? 'പുഴുവെട്ട് അപകടം$locationPhrase! ഉയർന്ന പ്രദേശത്തേക്ക് നീങ്ങുക'
            : 'Landslide danger$locationPhrase! Move to higher ground';
      default:
        return locale == 'ml'
            ? 'അടിയന്തിര അറിയിപ്പ്$locationPhrase'
            : 'Emergency alert$locationPhrase';
    }
  }

  Future<void> speak(String text, {String? language}) async {
    await _tts.setLanguage(language ?? 'ml-IN');
    await _tts.speak(text);
  }

  // Keep existing speech methods if needed
  Future<bool> get isListening async => Future.value(_speech.isListening);
  Future<void> stopListening() => _speech.stop();
}  