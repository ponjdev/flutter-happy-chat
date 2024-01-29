import 'package:flutter/material.dart';

class ChatTab extends StatefulWidget {
  @override
  _ChatTabState createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final String _userPhoneNumber = '+1234567890'; // Mock user's phone number
  final List<Map<String, String>> _messages = [
    {'phone': '+1234567890', 'text': "Hello there!"},
    {'phone': '+1234567890', 'text': "How's your day going?"},
    {'phone': '+0987654321', 'text': "Flutter is awesome!"},
    {'phone': '+0987654321', 'text': "Let's build a chat app."}
  ]; // Mockup messages with phone numbers

  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              var message = _messages[index];
              bool isUserMessage = message['phone'] == _userPhoneNumber;

              return Column(
                crossAxisAlignment: isUserMessage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: Text(
                      message['phone']!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: isUserMessage
                        ? MainAxisAlignment.end
                        : MainAxisAlignment.start,
                    children: [
                      Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blue[100]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "${message['text']}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        Divider(height: 1),
        _buildMessageInputField(),
      ],
    );
  }

  Widget _buildMessageInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: InputDecoration.collapsed(
                hintText: 'พิมพ์ข้อความ...',
              ),
              onSubmitted: (text) =>
                  _handleSubmitted(_textController.text, _userPhoneNumber),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              _handleSubmitted(_textController.text, _userPhoneNumber);
            },
          ),
        ],
      ),
    );
  }

  void _handleSubmitted(String text, String phone) {
    if (text.trim().isEmpty) {
      return;
    }
    setState(() {
      _messages.add({'phone': phone, 'text': text});
    });
    _textController.clear();

    FocusScope.of(context).requestFocus(FocusNode());
  }
}
