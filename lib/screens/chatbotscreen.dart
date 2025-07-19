import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dialogflow_grpc/dialogflow_grpc.dart';
import 'package:dialogflow_grpc/generated/google/cloud/dialogflow/v2/session.pb.dart' as dialogflow;
import 'package:uuid/uuid.dart';

class ChatbotScreen extends StatefulWidget {
  const ChatbotScreen({Key? key}) : super(key: key);

  @override
  State<ChatbotScreen> createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();
  late DialogflowGrpcV2Beta1 dialogflowClient;
  late String sessionId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initDialogflow();
    sessionId = const Uuid().v4(); // Create sessionId once per chat
  }

  Future<void> _initDialogflow() async {
    try {
      final serviceAccount = ServiceAccount.fromString(
        await rootBundle.loadString('assets/dialogflow_key.json'),
      );
      dialogflowClient = DialogflowGrpcV2Beta1.viaServiceAccount(serviceAccount);

      setState(() {
        _messages.add(ChatMessage(
          text: 'Hello! How can I assist you today?',
          isUser: false,
        ));
      });
    } catch (e) {
      debugPrint('Dialogflow init error: $e');
      setState(() {
        _messages.add(ChatMessage(
          text: '❗ Failed to connect to chatbot. Please check your key.',
          isUser: false,
        ));
      });
    }
  }

  Future<void> _sendMessage(String text) async {
    if (text.trim().isEmpty || _isLoading) return;

    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });

    try {
      final queryInput = dialogflow.QueryInput(
        text: dialogflow.TextInput(
          text: text,
          languageCode: 'en-US',
        ),
      );

     
      
    } catch (e) {
      debugPrint('Dialogflow error: $e');
      setState(() {
        _messages.add(ChatMessage(
          text: '⚠️ Sorry, an error occurred.',
          isUser: false,
        ));
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanal Chatbot'),
        backgroundColor: Colors.green[700],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  alignment: message.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: message.isUser ? Colors.green[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message.text,
                      style: TextStyle(
                        color: message.isUser ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    onSubmitted: (text) {
                      _sendMessage(text);
                      _textController.clear();
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    if (_textController.text.isNotEmpty) {
                      _sendMessage(_textController.text);
                      _textController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
          if (_isLoading) const LinearProgressIndicator(),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;

  ChatMessage({required this.text, required this.isUser});
}
