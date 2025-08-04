import 'package:flutter/material.dart';
import 'chat_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _handleSubmitted(String text) {
    _textController.clear();
    if (text.trim().isEmpty) return;

    final userMessage = ChatMessage(
      text: text,
      sender: 'Me',
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.insert(0, userMessage);
    });

    // Simulate a bot response
    final botMessage = ChatMessage(
      text: 'This is a simulated response to "${userMessage.text}"',
      sender: 'Bot',
      timestamp: DateTime.now().add(const Duration(seconds: 1)),
    );

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _messages.insert(0, botMessage);
      });
    });
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.secondary),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () => _handleSubmitted(_textController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat App'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: <Widget>[
          Flexible(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              reverse: true,
              itemBuilder: (_, int index) {
                final message = _messages[index];
                return _buildMessageItem(message);
              },
              itemCount: _messages.length,
            ),
          ),
          const Divider(height: 1.0),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(ChatMessage message) {
    final bool isMe = message.sender == 'Me';
    final alignment = isMe ? MainAxisAlignment.end : MainAxisAlignment.start;
    final crossAlignment = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    
    final avatar = Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: CircleAvatar(child: Text(message.sender[0])),
    );

    final messageBody = Flexible(
      child: Column(
        crossAxisAlignment: crossAlignment,
        children: <Widget>[
          Text(message.sender, style: Theme.of(context).textTheme.titleMedium),
          Container(
            margin: const EdgeInsets.only(top: 5.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: isMe ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Text(
              message.text,
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isMe ? [messageBody, avatar] : [avatar, messageBody],
      ),
    );
  }
}
