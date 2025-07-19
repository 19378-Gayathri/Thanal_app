import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:thanal_app/services/voice_service.dart'; // Your VoiceService class

final Map<String, String> localeToSpeechLang = {
  'en': 'en-IN',
  'ml': 'ml-IN',
  'hi': 'hi-IN',
};

class VoiceAssistScreen extends StatefulWidget {
  const VoiceAssistScreen({super.key});

  @override
  State<VoiceAssistScreen> createState() => _VoiceAssistScreenState();
}

class _VoiceAssistScreenState extends State<VoiceAssistScreen> {
  final _voiceService = VoiceService();
  late SpeechToText _speech;
  late FlutterTts _flutterTts;
  
  String _recognizedText = '';
  bool _isListening = false;
  bool _speechAvailable = false;
  bool _isEmergency = false;
  String _disasterType = '';
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _speech = SpeechToText();
    _flutterTts = FlutterTts();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    await _checkPermissions();
    await _voiceService.init();
    await _voiceService.initDialogflow();
    
    bool available = await _speech.initialize();
    setState(() => _speechAvailable = available);
    
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  Future<void> _checkPermissions() async {
    final micStatus = await Permission.microphone.request();
    final locationStatus = await Permission.location.request();
    
    if (micStatus != PermissionStatus.granted || 
        locationStatus != PermissionStatus.granted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(tr('permission_required')),
          content: Text(tr('mic_location_permission')),
          actions: [
            TextButton(
              onPressed: () => openAppSettings(),
              child: Text(tr('settings')),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _startListening() async {
    if (!_speechAvailable) return;

    String voiceLang = localeToSpeechLang[context.locale.languageCode] ?? 'en-IN';
    _currentPosition = await _getCurrentLocation();

    setState(() {
      _isListening = true;
      _recognizedText = '';
      _isEmergency = false;
    });

    await _speech.listen(
      localeId: voiceLang,
      onResult: (result) {
        setState(() => _recognizedText = result.recognizedWords);
        if (result.finalResult) {
          _processVoiceCommand(result.recognizedWords);
        }
      },
      listenFor: const Duration(seconds: 30),
      cancelOnError: true,
    );
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<void> _processVoiceCommand(String text) async {
    // Process with both systems
    _processDisasterCommand(text); // Keyword-based
    
    // AI processing
    final locale = context.locale.languageCode;
    final response = await _voiceService.processDisasterCommand(text, locale);
    
    setState(() {
      if (_shouldTriggerEmergency(response)) {
        _isEmergency = true;
        _disasterType = _extractDisasterType(response);
      }
    });
    
    if (_isEmergency) {
      await _speakEmergency(response);
      await _sendEmergencyReport();
    }
  }

  bool _shouldTriggerEmergency(String response) {
    return response.contains('flood') || 
           response.contains('earthquake') ||
           response.contains('വെള്ളപ്പൊക്ക') ||
           response.contains('ഭൂകമ്പ');
  }

  String _extractDisasterType(String response) {
    if (response.contains('flood') || response.contains('വെള്ളപ്പൊക്ക')) {
      return 'flood';
    } else if (response.contains('earthquake') || response.contains('ഭൂകമ്പ')) {
      return 'earthquake';
    }
    return 'general';
  }

  void _processDisasterCommand(String text) {
    final locale = context.locale.languageCode;
    text = text.toLowerCase();

    if (locale == 'ml') {
      if (text.contains('വെള്ളപ്പൊക്ക')) _handleDisaster('flood');
      if (text.contains('ഭൂകമ്പ')) _handleDisaster('earthquake');
    } 
    else if (locale == 'hi') {
      if (text.contains('बाढ़')) _handleDisaster('flood');
    }
    else {
      if (text.contains('flood')) _handleDisaster('flood');
      if (text.contains('earthquake')) _handleDisaster('earthquake');
    }
  }

  Future<void> _handleDisaster(String type) async {
    setState(() {
      _isEmergency = true;
      _disasterType = type;
    });
    await _speakEmergency(_getDisasterMessage(type));
  }

  String _getDisasterMessage(String type) {
    switch (type) {
      case 'flood': return tr('flood_alert');
      case 'earthquake': return tr('earthquake_alert');
      default: return tr('emergency_alert');
    }
  }

  Future<void> _speakEmergency(String message) async {
    String voiceLang = localeToSpeechLang[context.locale.languageCode] ?? 'en-IN';
    await _flutterTts.stop();
    await _flutterTts.setLanguage(voiceLang);
    await _flutterTts.speak(message);
  }

  Future<void> _sendEmergencyReport() async {
    // Implement your Firestore reporting here
    // Use _currentPosition and _disasterType
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _speakText() async {
    if (_recognizedText.isEmpty) return;
    await _speakEmergency(_recognizedText);
  }

  Color _getStatusColor() {
    return _isEmergency ? Colors.red : Theme.of(context).primaryColor;
  }

  String _getEmergencyStatus() {
    if (_isEmergency) {
      return tr('${_disasterType}_status');
    }
    return _isListening ? tr('listening') : tr('tap_to_speak');
  }

  @override
  void dispose() {
    _speech.stop();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('voice_assistant'))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status indicator
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _getEmergencyStatus(),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: _getStatusColor(),
                ),
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 20),

            // Recognized text
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _recognizedText.isNotEmpty 
                      ? _recognizedText 
                      : tr('speech_prompt'),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Voice controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(_isListening ? Icons.stop : Icons.mic),
                  label: Text(_isListening ? tr('stop') : tr('listen')),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _getStatusColor(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  ),
                  onPressed: _isListening ? _stopListening : _startListening,
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.volume_up),
                  label: Text(tr('speak')),
                  onPressed: _speakText,
                ),
              ],
            ),

            // Emergency actions
            if (_isEmergency) ...[
              const SizedBox(height: 20),
              EmergencyActionsPanel(
                disasterType: _disasterType,
                position: _currentPosition,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class EmergencyActionsPanel extends StatelessWidget {
  final String disasterType;
  final Position? position;

  const EmergencyActionsPanel({
    super.key,
    required this.disasterType,
    this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          tr('emergency_actions'),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            FilledButton(
              child: Text(tr('alert_authorities')),
              onPressed: () => _sendEmergencyReport(context),
            ),
            FilledButton(
              child: Text(tr('view_safety_tips')),
              onPressed: () => _showSafetyTips(context),
            ),
          ],
        ),
      ],
    );
  }

  void _sendEmergencyReport(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(tr('report_sent'))),
    );
  }

  void _showSafetyTips(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(tr('${disasterType}_safety_tips')),
        content: Text(tr('${disasterType}_tips_content')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(tr('close')),
          ),
        ],
      ),
    );
  }
}
