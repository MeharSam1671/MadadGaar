import 'package:flutter/material.dart';
import 'package:dialog_flowtter/dialog_flowtter.dart';

class ChatAIScreen extends StatefulWidget {
  const ChatAIScreen({super.key});

  @override
  State<ChatAIScreen> createState() => _ChatAIScreenState();
}

class _ChatAIScreenState extends State<ChatAIScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  late DialogFlowtter dialogFlowtter;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeDialogflow();
  }

  Future<void> _initializeDialogflow() async {
    try {
      dialogFlowtter =
          await DialogFlowtter.fromFile(path: 'assets/dialog_flow_auth.json');
      setState(() => _isInitialized = true);
    } catch (e) {
      print('Error initializing Dialogflow: $e');
      // Handle initialization error
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isNotEmpty && _isInitialized) {
      String userMessage = _controller.text.trim();

      // Add user message to the list
      setState(() {
        _messages.add({
          'message': userMessage,
          'isUserMessage': true,
        });
      });

      // Get response from Dialogflow
      try {
        DetectIntentResponse response = await dialogFlowtter.detectIntent(
          queryInput: QueryInput(text: TextInput(text: userMessage)),
        );

        if (response.message != null) {
          setState(() {
            _messages.add({
              'message': response.message?.text?.text?[0] ?? 'No response',
              'isUserMessage': false,
            });
          });
        }
      } catch (e) {
        print('Error getting Dialogflow response: $e');
        setState(() {
          _messages.add({
            'message': 'Sorry, there was an error processing your request.',
            'isUserMessage': false,
          });
        });
      }

      _controller.clear();
    }
  }

  @override
  void dispose() {
    dialogFlowtter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chat AI"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final messageData = _messages[index];
                return Align(
                  alignment: messageData['isUserMessage']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: messageData['isUserMessage']
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      messageData['message'],
                      style: TextStyle(
                        color: messageData['isUserMessage']
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Enter a message...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                    ),
                    onSubmitted: (text) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send_sharp, color: Colors.black),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
