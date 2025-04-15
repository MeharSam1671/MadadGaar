import 'dart:convert';

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
      dialogFlowtter = DialogFlowtter.fromJson({
        "type": "service_account",
        "project_id": "madadgaar-1122",
        "private_key_id": base64
            .decode("ZmEyNDVjMzY2NTYzYWNhNmRhOTAwMzMyM2VjOTZlYjJjNTZjNDNjYg==")
            .toString(),
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDnJ/KbLttiCiVz\nFPlVFDn1xhJHlg22s1xpKKTewAs4hDbH51xtzIlKiQdNQCz1bSav+lHpMtpXrUeH\n8/Es8KneVIlYA/It5JjjY46SvVlaHEzP7v6ngfRKYGUPBmgnkdu7fQXXZJ1nkmlI\ncmz4zH63lD7Bh0xcJOX2qIDN+0Dc6qvDtf1vmYkPQynpu49DSOoeneN8cHKLnDwk\nn3HVM7zpREqpwa3U7kqqb5KN+mUk6bFi3YwzbFDHeJhGvTLFvn5+tFYCh8d4/mqS\nZ2m1e83rof0XV3TGQJHNfY8giFsOjzidVDHL6o3muMZgeS5bRnSB+WNymxboNLVq\noplC0wmTAgMBAAECggEABICaMJyaiE/TR+kOLDKPKHLZs0xAayEWOTQh9fa+oTSu\nDnm6qqbTu8BshHwuA//Cw6W4B7dGWnPVE1hUh8AORvbVkAHPq0YrFi6/varzfRZV\nBq3Mhv24gORcw4yn5bFpGr9GKFpc2IIZC+Cyr6voAfJgwIs+mQLc+c9xZtGwgz0D\nbW+wLslk+vd9KCS1D17sMkmna3EJc7PbWDrra8cFQoxTpLswa8doFsHVLQWqofrN\nE0076oDKnH4xCpZWkkFp2ftQIYzHgdMRXcd5lUFQbUyROUaO3HY+1Cv276ov6Qi1\nfDaJhf+F7dt3umO/SA20/WjxKM/DJM9gP3wTJJS1hQKBgQD6lAuPkbHMY7US8jrJ\nqbbEE0VXA3duo1O2Hg0YU/ZaOSUmuZQ0f8SxYHtWV4o8DU+iDFQVB5wvCoN8mkwi\nRcOpZBmrlee2wKU5sBSN7OUdAbfH4UW382e5zFZky8Nv81EXG8m8aGW+S9jRDtDA\nGI3P1XBhNbkZqFOtI9cayP0BPQKBgQDsKFKQqr/5kHy3rgd/5Meuea1wehWdYQ1A\nhKniPUP/AGyDfOVYplGiezRS51p4YTdhCneSsvDmBJe+9t6INWD9iRLFhp0/BqXD\nHVEUyx25UGVwtI8NilPSZ+AMn7/jvfa7V58q+mwOzTuxKUCc0+usknpBKL5M8/eu\nwnfwqDFDDwKBgQCmR1F4nuTOTafd/7G1GpK2gFc2C43YdDdblYt5BlZmvp8BmIpZ\nYCPE1NJjlEmd2fNrBCVToy4oJSDlsXouD/9ry4ohS6NsqV+67TZmi7npyrcKw1lB\nXRsKtybpUjHJezvnSsBO7zP82FXzPJKXtnN8ZBVj3IONHB8SuMLH+nGxvQKBgFre\nFQ7nNKERcHu4sdgLLq460Xqi7yg0TMYThc6wpjY7coWRjCn1LRoo7/QqYwxI0+c6\nANJomfrXr4/iK7QbXeuQT7HDX0P+CdAuuqEWmqRQhAe+4gBixmgCYhpZaZt237Ys\nO+lsnCGB5MMBTYRKorcvUW07ASZZBWewGjh2byYPAoGAMqIesK+bNp33QSDUS/SY\noErvphzLUgA1Z4U/+uezq/jHl6056SA0zr8wVhaUn9g3rHXoSwiyBuhbqtH9sUJ3\nifZaH3arLYRoyCNYyNdH9Z8U8xWes5WfxPrx5CNtSSxhI1AJ921TFfQ0VxFzxkIK\nMQbSXIwmuh4sMr1FgjmXOYs=\n-----END PRIVATE KEY-----\n",
        "client_email": "chatbot@madadgaar-1122.iam.gserviceaccount.com",
        "client_id": "107095263874509379007",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/chatbot%40madadgaar-1122.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      });
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
